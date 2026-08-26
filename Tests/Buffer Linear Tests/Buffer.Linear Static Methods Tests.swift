import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap
import Storage_Contiguous
import Testing

@Suite("Buffer.Linear Static Operations")
struct LinearStaticTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

extension LinearStaticTests.Unit {

    @Test
    func `append increments count and stores element`() {
        let cap: Index<Int>.Count = 8
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            10,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            20,
            header: &header,
            storage: &storage
        )

        #expect(header.count == 2)

        let b = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.consumeBack(
            header: &header,
            storage: &storage
        )
        let a = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.consumeBack(
            header: &header,
            storage: &storage
        )
        #expect(a == 10)
        #expect(b == 20)

        storage.initialization = .empty
    }

    @Test
    func `removeFirst removes first and shifts`() {
        let cap: Index<Int>.Count = 8
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            10,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            20,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            30,
            header: &header,
            storage: &storage
        )

        let first = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear
            .removeFirst(header: &header, storage: &storage)
        #expect(first == 10)
        #expect(header.count == 2)

        let second = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear
            .removeFirst(header: &header, storage: &storage)
        #expect(second == 20)

        let third = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear
            .removeFirst(header: &header, storage: &storage)
        #expect(third == 30)

        #expect(header.isEmpty)
        storage.initialization = .empty
    }

    @Test
    func `consumeBack removes last element`() {
        let cap: Index<Int>.Count = 8
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            10,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            20,
            header: &header,
            storage: &storage
        )

        let last = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear
            .consumeBack(header: &header, storage: &storage)
        #expect(last == 20)
        #expect(header.count == 1)

        let first = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear
            .consumeBack(header: &header, storage: &storage)
        #expect(first == 10)
        #expect(header.isEmpty)

        storage.initialization = .empty
    }

    @Test
    func `deinitializeAll clears everything`() {
        let cap: Index<Int>.Count = 8
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            1,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            2,
            header: &header,
            storage: &storage
        )
        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            3,
            header: &header,
            storage: &storage
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.deinitializeAll(
            header: &header,
            storage: &storage
        )

        #expect(header.isEmpty)
    }

    @Test
    func `initialization stays .one for linear`() {
        let cap: Index<Int>.Count = 8
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        #expect(header.initialization == .empty)

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            42,
            header: &header,
            storage: &storage
        )
        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == 0)
            #expect(range.upperBound == 1)

        default:
            Issue.record("Expected .one")
        }

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.deinitializeAll(
            header: &header,
            storage: &storage
        )
    }
}

extension LinearStaticTests.EdgeCase {

    @Test
    func `append then consumeBack round-trips single element`() {
        let cap: Index<Int>.Count = 4
        var header = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>.create(
            minimumCapacity: cap
        )

        Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.append(
            42,
            header: &header,
            storage: &storage
        )
        let v = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.consumeBack(
            header: &header,
            storage: &storage
        )
        #expect(v == 42)
        #expect(header.isEmpty)

        storage.initialization = .empty
    }
}
