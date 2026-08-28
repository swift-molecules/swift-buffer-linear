import Buffer_Linear
import Buffer_Linear_Test_Support
import Cardinal
import Memory_Allocator_Primitive
import Memory
import Memory_Small
import Storage_Memory
import Testing
import Tagged

@Suite("Buffer.Linear.Header")
struct LinearHeaderTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
}

extension LinearHeaderTests.Unit {

    @Test
    func `init sets count to zero`() {
        let cap: Tagged<Int, Cardinal> = .init(8)
        let header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Header(
            capacity: .init(8)
        )
        #expect(header.count == .init(0))
        #expect(header.capacity == cap)
    }

    @Test
    func `isEmpty and isFull`() {
        let cap: Tagged<Int, Cardinal> = .init(4)
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Header(
            capacity: cap
        )
        #expect(header.isEmpty)
        #expect(!header.isFull)

        header.count = cap
        #expect(!header.isEmpty)
        #expect(header.isFull)
    }

    @Test
    func `initialization is always .empty or .one`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Header(
            capacity: .init(8)
        )

        switch header.initialization {
        case .empty:
            break

        default:
            Issue.record("Expected .empty")
        }

        header.count = .init(5)
        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == .init(0))
            #expect(range.upperBound == .init(5))

        default:
            Issue.record("Expected .one(0..<5)")
        }
    }
}

extension LinearHeaderTests.EdgeCase {

    @Test
    func `initialization linearize — always starts from zero`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Header(
            capacity: .init(8)
        )
        header.count = .init(3)

        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == .init(0))
            #expect(range.upperBound == .init(3))

        default:
            Issue.record("Expected .one")
        }
    }

    @Test
    func `full header initialization covers entire capacity`() {
        var header = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear.Header(
            capacity: .init(4)
        )
        header.count = .init(4)
        switch header.initialization {
        case .one(let range):
            #expect(range.lowerBound == .init(0))
            #expect(range.upperBound == .init(4))

        default:
            Issue.record("Expected .one(0..<4)")
        }
    }
}
