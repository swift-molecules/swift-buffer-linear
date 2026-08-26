import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap
import Storage_Contiguous
import Testing

@Suite("Buffer.Linear clone")
struct LinearCloneTests {

    @Test
    func `clone produces independent storage`() {
        var original = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        let cloned = original.clone()

        original.append(999)

        #expect(original.count == 4)
        #expect(cloned.count == 3)
    }

    @Test
    func `clone sizes capacity to count`() {
        var source = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(
            minimumCapacity: 0
        )
        source.reserveCapacity(100)
        source.append(1)
        source.append(2)

        let cloned = source.clone()

        #expect(cloned.count == 2)
        #expect(cloned.capacity >= 2)

        #expect(cloned.capacity < source.capacity)
    }

    @Test
    func `clone of empty buffer`() {
        let source = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(
            minimumCapacity: 0
        )
        let cloned = source.clone()
        let clonedIsEmpty = cloned.isEmpty
        #expect(clonedIsEmpty)
    }

    @Test
    func `clone with explicit capacity`() {
        var source = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        let cloned = source.clone(capacity: 50)

        #expect(cloned.count == 3)
        #expect(cloned.capacity >= 50)

        source.append(999)
        #expect(cloned.count == 3)
    }
}
