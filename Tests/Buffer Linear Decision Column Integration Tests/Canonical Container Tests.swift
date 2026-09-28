import Buffer_Linear
import Buffer_Linear_Bounded
import Buffer
import Storage
import Memory_Allocator
import Memory
import Store
import Index
import Tagged
import Cardinal
import Testing

private struct MoveOnly: ~Copyable { var v: Int }

@Suite
struct CanonicalContainerIntegrationTests {
    @Test
    func `Heap spells the growable heap column for both element kinds`() {
            var c = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(minimumCapacity: Tagged<Int, Cardinal>(Cardinal(UInt(2))))
            c.append(1)
            c.append(2)
            c.append(3)
            #expect(c.count == 3)
            var m = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<MoveOnly>>.Linear()
            m.append(MoveOnly(v: 7))
            #expect(m.count == 1)
        }

    @Test
    func `Bounded spells the fixed-capacity linear column`() {
            let c = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear.Bounded(minimumCapacity: 4)
            let empty = c.isEmpty
            #expect(empty)
        }

    @Test
    func `Inline spells the typed inline column with its value-generic capacity`() {
            var s = Store.Inline<Int, 4>()
            s.initialize(at: 0, to: 11)
            #expect(s.count == 1)
            let taken = s.move(at: 0)
            #expect(taken == 11)
        }
}
