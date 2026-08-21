import Buffer_Linear_Primitives
import Buffer_Linear_Primitives_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Storage_Contiguous_Primitives
import Store_Protocol_Primitives
import Testing

private func exerciseSeamSwap<S>(
    _ store: inout S,
    _ i: Index<S.Element>,
    _ j: Index<S.Element>
) where S: Store.`Protocol`, S: ~Copyable {
    store.swapAt(i, j)
}

@Suite("Buffer.Linear.Bounded+Store.Protocol")
struct LinearBoundedStoreProtocolTests {
    @Suite struct Regression {}
}

extension LinearBoundedStoreProtocolTests.Regression {

    @Test
    func `swapAt exchanges two interior elements through the generic Store Protocol seam`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Bounded(
            minimumCapacity: 4
        )
        _ = buffer.append(10)
        _ = buffer.append(20)
        _ = buffer.append(30)

        exerciseSeamSwap(&buffer, Index<Int>(Ordinal(UInt(0))), Index<Int>(Ordinal(UInt(1))))

        #expect(buffer[Index<Int>(Ordinal(UInt(0)))] == 20)
        #expect(buffer[Index<Int>(Ordinal(UInt(1)))] == 10)
        #expect(buffer[Index<Int>(Ordinal(UInt(2)))] == 30)
        #expect(buffer.count == 3)
    }

    @Test
    func `swapAt with equal indices is a no-op`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Bounded(
            minimumCapacity: 4
        )
        _ = buffer.append(10)
        _ = buffer.append(20)

        exerciseSeamSwap(&buffer, Index<Int>(Ordinal(UInt(1))), Index<Int>(Ordinal(UInt(1))))

        #expect(buffer[Index<Int>(Ordinal(UInt(0)))] == 10)
        #expect(buffer[Index<Int>(Ordinal(UInt(1)))] == 20)
    }
}
