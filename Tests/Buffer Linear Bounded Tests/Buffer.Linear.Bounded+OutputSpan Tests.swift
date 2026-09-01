import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Testing

@Suite("Buffer.Linear.Bounded + OutputSpan")
struct LinearBoundedOutputSpanTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
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

extension LinearBoundedOutputSpanTests.Unit {

    @Test
    func `init fills the OutputSpan exactly`() throws {

        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(4)
        ) { span in
            span.append(10)
            span.append(20)
            span.append(30)
            span.append(40)
        }
        #expect(buffer.count == .init(4))
        #expect(buffer.capacity == .init(4))
    }

    @Test
    func `init with partial population leaves correct count`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(8)
        ) { span in
            span.append(1)
            span.append(2)
            span.append(3)
        }
        #expect(buffer.count == .init(3))
        #expect(buffer.capacity == .init(8))
        #expect(buffer.isFull == false)
    }

    @Test
    func `init with empty closure yields empty buffer`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(4)
        ) { _ in }
        #expect(buffer.isEmpty == true)
        #expect(buffer.count == .zero)
        #expect(buffer.capacity == .init(4))
    }

    @Test
    func `init with zero capacity`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(0)
        ) { _ in }
        #expect(buffer.isEmpty == true)
        #expect(buffer.count == .zero)
    }

    @Test
    func `capacity is pinned to the exact requested capacity`() throws {
        let four = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(4)
        ) { _ in }
        #expect(four.capacity == .init(4))

        let nine = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(9)
        ) { _ in }
        #expect(nine.capacity == .init(9))
    }
}

extension LinearBoundedOutputSpanTests.EdgeCase {

    @Test
    func `OutputSpan freeCapacity decreases with appends`() throws {
        var captured: [Int] = []
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(3)
        ) { span in
            captured.append(span.freeCapacity)
            span.append(100)
            captured.append(span.freeCapacity)
            span.append(200)
            captured.append(span.freeCapacity)
        }
        #expect(captured == [3, 2, 1])
        #expect(buffer.count == .init(2))
    }

    @Test
    func `OutputSpan isFull reflects requested capacity`() throws {
        var fullAtEnd: Bool = false
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            capacity: .init(2)
        ) { span in
            span.append(1)
            span.append(2)
            fullAtEnd = span.isFull
        }
        #expect(fullAtEnd == true)
        #expect(buffer.count == .init(2))
    }
}

extension LinearBoundedOutputSpanTests.NonCopyable {

    @Test
    func `init with noncopyable elements`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear
            .Bounded(capacity: .init(3)) { span in
                span.append(MoveOnly(1))
                span.append(MoveOnly(2))
                span.append(MoveOnly(3))
            }
        #expect(buffer.count == .init(3))
    }

    @Test
    func `init partial-populate with noncopyable elements`() throws {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear
            .Bounded(capacity: .init(5)) { span in
                span.append(MoveOnly(42))
            }
        #expect(buffer.count == .init(1))
        #expect(buffer.capacity == .init(5))
    }
}

extension LinearBoundedOutputSpanTests.Throwing {

    @Test
    func `init throws propagates the error`() {
        #expect(throws: FixtureError.deliberate) {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
                capacity: .init(4)
            ) { span throws(FixtureError) in
                span.append(1)
                span.append(2)
                throw FixtureError.deliberate
            }
        }
    }

    @Test
    func `init throws with noncopyable elements — elements cleaned up`() {

        #expect(throws: FixtureError.deliberate) {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<MoveOnly>>.Linear
                .Bounded(capacity: .init(3)) { span throws(FixtureError) in
                    span.append(MoveOnly(1))
                    span.append(MoveOnly(2))
                    throw FixtureError.deliberate
                }
        }
    }
}
