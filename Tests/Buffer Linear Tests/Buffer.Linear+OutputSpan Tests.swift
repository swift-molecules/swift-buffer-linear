import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Testing

@Suite("Buffer.Linear + OutputSpan")
struct LinearOutputSpanTests {
    @Suite struct Init {}
    @Suite struct Append {}
    @Suite struct Edit {}
    @Suite struct NonCopyable {}
    @Suite struct Throwing {}
}

private struct MoveOnly: ~Copyable {
    let value: Int
    init(_ value: Int) { self.value = value }
}

private enum FixtureError: Swift.Error, Equatable {
    case deliberate
}

extension LinearOutputSpanTests.Init {

    @Test
    func `init with capacity and full population`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            capacity: .init(4)
        ) { span in
            span.append(10)
            span.append(20)
            span.append(30)
            span.append(40)
        }
        #expect(buffer.count == .init(4))
    }

    @Test
    func `init with partial population leaves correct count`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            capacity: .init(8)
        ) { span in
            span.append(1)
            span.append(2)
        }
        #expect(buffer.count == .init(2))
        #expect(buffer.capacity >= .init(8))
    }

    @Test
    func `init with empty closure`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            capacity: .init(4)
        ) { _ in }
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `init with zero capacity`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            capacity: .init(0)
        ) { _ in }
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        #expect(buffer.count == .zero)
    }
}

extension LinearOutputSpanTests.Append {

    @Test
    func `append adds to existing buffer`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(2)
        )
        buffer.append(1)
        buffer.append(2)

        buffer.append(addingCapacity: .init(3)) { span in
            span.append(10)
            span.append(20)
            span.append(30)
        }
        #expect(buffer.count == .init(5))
    }

    @Test
    func `append triggers growth when required exceeds capacity`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(2)
        )
        buffer.append(1)
        buffer.append(2)
        let capacityBefore = buffer.capacity

        buffer.append(addingCapacity: .init(10)) { span in
            for i in 0..<10 {
                span.append(100 + i)
            }
        }
        #expect(buffer.count == .init(12))
        #expect(buffer.capacity >= .init(12))
        #expect(buffer.capacity > capacityBefore)
    }

    @Test
    func `append with partial population commits what was added`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(4)
        )
        buffer.append(1)

        buffer.append(addingCapacity: .init(5)) { span in
            span.append(10)
            span.append(20)

        }
        #expect(buffer.count == .init(3))
    }

    @Test
    func `append with zero addingCapacity is a noop`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(4)
        )
        buffer.append(1)
        buffer.append(2)

        var capturedCapacity = -1
        var capturedIsFull = false
        buffer.append(addingCapacity: .init(0)) { span in
            capturedCapacity = span.capacity
            capturedIsFull = span.isFull
        }
        #expect(capturedCapacity == 0)
        #expect(capturedIsFull)
        #expect(buffer.count == .init(2))
    }
}

extension LinearOutputSpanTests.Edit {

    @Test
    func `edit can append beyond current count up to capacity`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        buffer.reserveCapacity(.init(10))

        buffer.edit { span in
            span.append(4)
            span.append(5)
        }
        #expect(buffer.count == .init(5))
    }

    @Test
    func `edit can remove elements`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3, 4, 5,
        ])

        buffer.edit { span in
            _ = span.removeLast()
            _ = span.removeLast()
        }
        #expect(buffer.count == .init(3))
    }

    @Test
    func `edit returns the closure result`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])

        let doubled: Int = buffer.edit { span in
            return span.count * 2
        }
        #expect(doubled == 6)
    }

    @Test
    func `edit preserves state on throw`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.reserveCapacity(.init(10))

        do {
            try buffer.edit { span throws(FixtureError) in
                span.append(40)
                span.append(50)
                throw FixtureError.deliberate
            }
            Issue.record("Expected throw")
        } catch {
            #expect(error == .deliberate)
        }

        #expect(buffer.count == .init(5))
    }
}

extension LinearOutputSpanTests.NonCopyable {

    @Test
    func `init with noncopyable elements`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear(
            capacity: .init(3)
        ) { span in
            span.append(MoveOnly(1))
            span.append(MoveOnly(2))
            span.append(MoveOnly(3))
        }
        #expect(buffer.count == .init(3))
    }

    @Test
    func `append with noncopyable elements, triggering growth`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear(
            minimumCapacity: .init(2)
        )
        buffer.append(MoveOnly(1))
        buffer.append(addingCapacity: .init(4)) { span in
            span.append(MoveOnly(10))
            span.append(MoveOnly(20))
            span.append(MoveOnly(30))
            span.append(MoveOnly(40))
        }
        #expect(buffer.count == .init(5))
    }
}

extension LinearOutputSpanTests.Throwing {

    @Test
    func `init throw destroys partial state and propagates error`() {
        #expect(throws: FixtureError.deliberate) {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
                capacity: .init(4)
            ) { span throws(FixtureError) in
                span.append(1)
                span.append(2)
                throw FixtureError.deliberate
            }
        }
    }

    @Test
    func `append throw preserves already-initialized elements`() throws {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(2)
        )
        buffer.append(100)

        do {
            try buffer.append(addingCapacity: .init(5)) { span throws(FixtureError) in
                span.append(1)
                span.append(2)
                throw FixtureError.deliberate
            }
            Issue.record("Expected throw")
        } catch {
            #expect(error == .deliberate)
        }

        #expect(buffer.count == .init(3))
    }

    @Test
    func `init throw with noncopyable elements propagates`() {
        #expect(throws: FixtureError.deliberate) {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear(
                capacity: .init(3)
            ) { span throws(FixtureError) in
                span.append(MoveOnly(1))
                throw FixtureError.deliberate
            }
        }
    }
}
