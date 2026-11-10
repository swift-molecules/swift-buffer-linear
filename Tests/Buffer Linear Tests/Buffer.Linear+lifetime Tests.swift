import Buffer_Linear
import Buffer_Linear_Test_Support
import Cardinal
import Index
import Memory
import Memory_Allocator
import Memory_Small
import Ordinal
import Storage
import Store
import Tagged
import Testing

private typealias Column<Element: ~Copyable> = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear

private final class Census {
    var destroyed: [Int] = []
}

private final class Tracked {
    let id: Int
    private let census: Census

    init(_ id: Int, in census: Census) {
        self.id = id
        self.census = census
    }

    deinit { census.destroyed.append(id) }
}

private func slot<Element>(_ rawValue: Int) -> Index<Element> {
    Index(_unchecked: Ordinal(UInt(rawValue)))
}

@Suite
struct `Buffer.Linear Lifetime Tests` {

    @Test
    func `growth keeps every element in order and destroys none`() {
        let census = Census()
        do {
            var buffer = Column<Tracked>(minimumCapacity: .one)
            (0..<100).forEach { id in
                buffer.append(Tracked(id, in: census))
            }

            #expect(census.destroyed == [])
            #expect(buffer.count == .init(_unchecked: Cardinal(100)))
            var ids: [Int] = []
            (0..<100).forEach { position in
                ids.append(buffer[slot(position)].id)
            }
            #expect(ids == Array(0..<100))
        }
        #expect(census.destroyed.sorted() == Array(0..<100))
    }

    @Test
    func `reserving capacity moves the elements across unchanged`() {
        var buffer = Column<String>(["a long enough string to live on the heap", "second", "third"])

        buffer.reserveCapacity(.init(_unchecked: Cardinal(64)))

        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
        #expect(buffer.capacity >= .init(_unchecked: Cardinal(64)))
        var elements: [String] = []
        (0..<3).forEach { position in
            elements.append(buffer[slot(position)])
        }
        #expect(elements == ["a long enough string to live on the heap", "second", "third"])
    }

    @Test
    func `clone holds the same elements in order and keeps them alive on its own`() {
        let census = Census()
        do {
            var copy: Column<Tracked>
            do {
                var original = Column<Tracked>(minimumCapacity: .init(_unchecked: Cardinal(8)))
                (0..<5).forEach { id in
                    original.append(Tracked(id, in: census))
                }
                copy = original.clone()
                original.removeAll(keepingCapacity: true)
            }
            #expect(census.destroyed == [])
            #expect(copy.count == .init(_unchecked: Cardinal(5)))
            var ids: [Int] = []
            (0..<5).forEach { position in
                ids.append(copy[slot(position)].id)
            }
            #expect(ids == [0, 1, 2, 3, 4])
            copy.append(Tracked(5, in: census))
            #expect(copy.count == .init(_unchecked: Cardinal(6)))
        }
        #expect(census.destroyed.sorted() == [0, 1, 2, 3, 4, 5])
    }

    @Test
    func `clone with a larger capacity holds the same elements`() {
        let original = Column<String>(["a long enough string to live on the heap", "second"])

        let copy = original.clone(capacity: .init(_unchecked: Cardinal(32)))

        #expect(copy.count == .init(_unchecked: Cardinal(2)))
        #expect(copy.capacity >= .init(_unchecked: Cardinal(32)))
        var elements: [String] = []
        (0..<2).forEach { position in
            elements.append(copy[slot(position)])
        }
        #expect(elements == ["a long enough string to live on the heap", "second"])
    }

    @Test
    func `removing all while keeping capacity destroys each element once and leaves the buffer reusable`() {
        let census = Census()
        do {
            var buffer = Column<Tracked>(minimumCapacity: .init(_unchecked: Cardinal(8)))
            (0..<5).forEach { id in
                buffer.append(Tracked(id, in: census))
            }
            let capacity = buffer.capacity

            buffer.removeAll(keepingCapacity: true)

            #expect(census.destroyed.sorted() == [0, 1, 2, 3, 4])
            let isEmpty = buffer.isEmpty
            #expect(isEmpty)
            #expect(buffer.capacity == capacity)

            buffer.append(Tracked(5, in: census))
            #expect(buffer.count == .one)
            let id = buffer[.zero].id
            #expect(id == 5)
        }
        #expect(census.destroyed.sorted() == [0, 1, 2, 3, 4, 5])
    }

    @Test
    func `removing all destroys the elements the header counts, whatever the storage's own ledger says`() {
        let census = Census()
        var storage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Tracked>.create(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        (0..<3).forEach { id in
            storage.initialize(at: slot(id), to: Tracked(id, in: census))
        }
        storage.initialization = .empty
        var header = Column<Tracked>.Header(capacity: storage.capacity)
        header.count = .init(_unchecked: Cardinal(3))
        var buffer = Column<Tracked>(header: header, storage: storage)

        buffer.removeAll(keepingCapacity: true)

        #expect(census.destroyed.sorted() == [0, 1, 2])
        let isEmpty = buffer.isEmpty
        #expect(isEmpty)
    }

    @Test
    func `removing all without keeping capacity destroys each element once`() {
        let census = Census()
        var buffer = Column<Tracked>(minimumCapacity: .init(_unchecked: Cardinal(8)))
        (0..<3).forEach { id in
            buffer.append(Tracked(id, in: census))
        }

        buffer.removeAll(keepingCapacity: false)

        #expect(census.destroyed.sorted() == [0, 1, 2])
        let isEmpty = buffer.isEmpty
        #expect(isEmpty)
    }

    @Test
    func `removing all from an empty buffer changes nothing`() {
        var buffer = Column<String>(minimumCapacity: .init(_unchecked: Cardinal(4)))

        buffer.removeAll(keepingCapacity: true)

        let isEmpty = buffer.isEmpty
        #expect(isEmpty)
        buffer.append("first")
        #expect(buffer.count == .one)
    }
}
