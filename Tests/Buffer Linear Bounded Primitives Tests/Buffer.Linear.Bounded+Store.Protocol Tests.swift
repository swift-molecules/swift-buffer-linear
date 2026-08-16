import Buffer_Linear_Primitives
import Buffer_Linear_Primitives_Test_Support
import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Storage_Contiguous_Primitives
import Store_Protocol_Primitives
import Testing

// MARK: - Generic seam tunnel
//
// Mirrors `Buffer.Linear+Store.Protocol Tests.swift`: reaches `swapAt(_:_:)` through the bare
// `Store.`Protocol`` constraint, the same path a higher-tier ADT generic over the seam would use,
// never through `Buffer.Linear.Bounded`'s own concrete `.swap(at:with:)` convenience.
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

    // Regression coverage for buffer-linear#3, the Bounded sibling of the growable-column fix:
    // `Buffer.Linear.Bounded` inherited the same defaulted `swapAt(_:_:)`, built from its own
    // trailing-slot-only `move(at:)` / `initialize(at:to:)`, and trapped on interior exchanges.
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
