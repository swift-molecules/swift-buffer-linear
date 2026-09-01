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

@Suite("Buffer.Linear.Bounded+Builder")
struct LinearBoundedBuilderTests {
    @Suite struct WithinCapacity {}
    @Suite struct Overflow {}
    @Suite struct NonCopyable {}
}

private struct Move: ~Copyable {
    let value: Int
    init(_ value: Int) { self.value = value }
}

extension LinearBoundedBuilderTests.WithinCapacity {

    @Test
    func `Constructs within capacity`() throws {
        let buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear
            .Bounded(minimumCapacity: .init(_unchecked: Cardinal(8))) {
                1
                2
                3
            }
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
    }
}

extension LinearBoundedBuilderTests.Overflow {

    @Test
    func `Throws on overflow`() {
        do {
            _ = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded(
                minimumCapacity: .init(_unchecked: Cardinal(2))
            ) {
                1
                2
                3
            }
            Issue.record("expected throw")
        } catch let error {
            #expect((error as? Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Bounded.Error) == .capacityExceeded)
        }
    }
}

extension LinearBoundedBuilderTests.NonCopyable {

    @Test
    func `Constructs noncopyable bounded buffer`() throws {
        let buffer = try Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Move>>.Linear
            .Bounded(minimumCapacity: .init(_unchecked: Cardinal(4))) {
                Move(1)
                Move(2)
            }
        #expect(buffer.count == .init(_unchecked: Cardinal(2)))
    }
}
