import Store_Ledgered
import Cardinal
import Tagged
import Store_Operations
import Store_Initialization
import Store_Protocol
import Store
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
import Cardinal_Carrier
import Cardinal_Tagged
import Index
import Buffer_Linear
import Buffer_Linear_Test_Support
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Storage
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
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        _ = buffer.append(10)
        _ = buffer.append(20)
        _ = buffer.append(30)

        exerciseSeamSwap(&buffer, Index<Int>(_unchecked: Ordinal(0)), Index<Int>(_unchecked: Ordinal(1)))

        #expect(buffer[Index<Int>(_unchecked: Ordinal(0))] == 20)
        #expect(buffer[Index<Int>(_unchecked: Ordinal(1))] == 10)
        #expect(buffer[Index<Int>(_unchecked: Ordinal(2))] == 30)
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
    }

    @Test
    func `swapAt with equal indices is a no-op`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        _ = buffer.append(10)
        _ = buffer.append(20)

        exerciseSeamSwap(&buffer, Index<Int>(_unchecked: Ordinal(1)), Index<Int>(_unchecked: Ordinal(1)))

        #expect(buffer[Index<Int>(_unchecked: Ordinal(0))] == 10)
        #expect(buffer[Index<Int>(_unchecked: Ordinal(1))] == 20)
    }
}
