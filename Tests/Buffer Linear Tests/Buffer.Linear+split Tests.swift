import Store_Ledgered
import Tagged
import Cardinal
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

@Suite("Buffer.Linear + split")
struct LinearSplitTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

extension LinearSplitTests.Unit {

    @Test
    func `split preserves order in independently owned parts`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            [10, 20, 30, 40]
        )
        let split = buffer.split(maximum: .init(_unchecked: Cardinal(2)))
        var prefix: [Int] = []
        var remainder: [Int] = []
        split.prefix.forEach { prefix.append($0) }
        split.remainder.forEach { remainder.append($0) }

        #expect(prefix == [10, 20])
        #expect(remainder == [30, 40])
    }
}

extension LinearSplitTests.EdgeCase {

    @Test
    func `split with zero maximum has an empty prefix`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            [10, 20]
        )
        let split = buffer.split(maximum: .zero)
        let prefixCount = split.prefix.count
        var remainder: [Int] = []
        split.remainder.forEach { remainder.append($0) }

        #expect(prefixCount == .zero)
        #expect(remainder == [10, 20])
    }

    @Test
    func `split beyond count has an empty remainder`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            [10, 20]
        )
        let split = buffer.split(maximum: .init(_unchecked: Cardinal(3)))
        var prefix: [Int] = []
        let remainderCount = split.remainder.count
        split.prefix.forEach { prefix.append($0) }

        #expect(prefix == [10, 20])
        #expect(remainderCount == .zero)
    }
}
