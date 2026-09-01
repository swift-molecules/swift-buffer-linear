import Store_Ledgered
import Cardinal
import Tagged
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
import Cardinal_Carrier
import Cardinal_Tagged
import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Testing

@Suite("Buffer.Linear reallocate")
struct LinearReallocateTests {

    @Test
    func `reallocate can grow`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        let initial = buffer.capacity
        buffer.reallocate(capacity: .init(_unchecked: Cardinal(100)))
        #expect(buffer.capacity >= .init(_unchecked: Cardinal(100)))
        #expect(buffer.capacity > initial)
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
    }

    @Test
    func `reallocate can shrink`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(0))
        )
        buffer.reserveCapacity(.init(_unchecked: Cardinal(100)))
        buffer.append(1)
        buffer.append(2)
        let beforeShrink = buffer.capacity
        buffer.reallocate(capacity: .init(_unchecked: Cardinal(5)))
        #expect(buffer.count == .init(_unchecked: Cardinal(2)))
        #expect(buffer.capacity < beforeShrink)
        #expect(buffer.capacity >= .init(_unchecked: Cardinal(2)))
    }

    @Test
    func `reallocate preserves existing elements on grow`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.reallocate(capacity: .init(_unchecked: Cardinal(50)))
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))

        #expect(buffer.span.count == 3)
    }

    @Test
    func `reallocate preserves existing elements on shrink`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(0))
        )
        buffer.reserveCapacity(.init(_unchecked: Cardinal(100)))
        buffer.append(42)
        buffer.append(43)
        buffer.reallocate(capacity: .init(_unchecked: Cardinal(2)))
        #expect(buffer.count == .init(_unchecked: Cardinal(2)))
        #expect(buffer.span.count == 2)
    }

    @Test
    func `reallocate to capacity equal to count`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        buffer.reserveCapacity(.init(_unchecked: Cardinal(100)))
        buffer.reallocate(capacity: .init(_unchecked: Cardinal(3)))
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
        #expect(buffer.capacity >= .init(_unchecked: Cardinal(3)))
    }
}
