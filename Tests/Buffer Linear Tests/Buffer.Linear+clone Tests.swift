import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Testing

@Suite("Buffer.Linear clone")
struct LinearCloneTests {

    @Test
    func `clone produces independent storage`() {
        var original = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        let cloned = original.clone()

        original.append(999)

        #expect(original.count == .init(4))
        #expect(cloned.count == .init(3))
    }

    @Test
    func `clone sizes capacity to count`() {
        var source = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(0)
        )
        source.reserveCapacity(.init(100))
        source.append(1)
        source.append(2)

        let cloned = source.clone()

        #expect(cloned.count == .init(2))
        #expect(cloned.capacity >= .init(2))

        #expect(cloned.capacity < source.capacity)
    }

    @Test
    func `clone of empty buffer`() {
        let source = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(0)
        )
        let cloned = source.clone()
        let clonedIsEmpty = cloned.isEmpty
        #expect(clonedIsEmpty)
    }

    @Test
    func `clone with explicit capacity`() {
        var source = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        let cloned = source.clone(capacity: .init(50))

        #expect(cloned.count == .init(3))
        #expect(cloned.capacity >= .init(50))

        source.append(999)
        #expect(cloned.count == .init(3))
    }
}
