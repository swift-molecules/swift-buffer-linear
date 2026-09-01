import Store_Ledgered
import Ordinal_Cardinal
import Ordinal_Tagged
import Ordinal
import Cardinal_Carrier
import Cardinal_Tagged
import Buffer_Linear
import Buffer_Linear_Test_Support
import Cardinal
import Memory_Allocator
import Memory
import Memory_Small
import Storage_Memory
import Tagged
import Testing

@Suite("Buffer.Linear")
struct LinearGrowableTests {
    @Suite struct Unit {}
    @Suite struct EdgeCase {}
    @Suite struct Integration {}
}

extension LinearGrowableTests.Unit {

    @Test
    func `append and removeFirst`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        buffer.append(10)
        buffer.append(20)
        buffer.append(30)

        #expect(buffer.remove.first() == 10)
        #expect(buffer.remove.first() == 20)
        #expect(buffer.remove.first() == 30)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `append and removeLast`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        buffer.append(10)
        buffer.append(20)
        buffer.append(30)

        #expect(buffer.remove.last() == 30)
        #expect(buffer.remove.last() == 20)
        #expect(buffer.remove.last() == 10)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `growth doubles capacity`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(2))
        )
        let originalCap = buffer.capacity

        var i = 0
        let needed = Int(originalCap.underlying.rawValue) + 1
        while i < needed {
            buffer.append(i * 10)
            i += 1
        }

        #expect(buffer.capacity.underlying.rawValue > originalCap.underlying.rawValue)

        i = 0
        while i < needed {
            #expect(buffer.remove.first() == i * 10)
            i += 1
        }
    }

    @Test
    func `drain removes all in front-to-back order`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        var drained: [Int] = []
        buffer.drain { drained.append($0) }
        #expect(drained == [10, 20, 30])
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `removeAll clears buffer`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            1, 2, 3,
        ])
        buffer.remove.all()
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `peekFront and peekBack (Copyable)`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        #expect(buffer.peek.front == 10)
        #expect(buffer.peek.back == 30)
    }

    @Test
    func `Iterable iteration (Copyable)`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])

        var collected: [Int] = []
        buffer.forEach { collected.append($0) }
        #expect(collected == [10, 20, 30])
    }

    @Test
    func `single element`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(1))
        )
        buffer.append(42)
        #expect(buffer.count == .init(_unchecked: Cardinal(1)))
        #expect(buffer.remove.last() == 42)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `reserveCapacity grows if needed`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(2))
        )
        buffer.reserveCapacity(.init(_unchecked: Cardinal(100)))
        #expect(buffer.capacity.underlying.rawValue >= 100)
    }

    @Test
    func `forEach visits all elements`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        var visited: [Int] = []
        buffer.forEach { visited.append($0) }
        #expect(visited == [10, 20, 30])
    }

    @Test
    func `subscript read and write`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        #expect(buffer[.init(_unchecked: Ordinal(0))] == 10)
        #expect(buffer[.init(_unchecked: Ordinal(1))] == 20)
        #expect(buffer[.init(_unchecked: Ordinal(2))] == 30)
        buffer[.init(_unchecked: Ordinal(1))] = 999
        #expect(buffer[.init(_unchecked: Ordinal(1))] == 999)
    }

    @Test
    func `swap exchanges two elements`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.swap(at: .init(_unchecked: Ordinal(0)), with: .init(_unchecked: Ordinal(2)))
        #expect(buffer[.init(_unchecked: Ordinal(0))] == 30)
        #expect(buffer[.init(_unchecked: Ordinal(2))] == 10)
    }

    @Test
    func `truncate removes trailing elements`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30, 40, 50,
        ])
        buffer.truncate(to: .init(_unchecked: Cardinal(3)))
        #expect(buffer.count == .init(_unchecked: Cardinal(3)))
        #expect(buffer.peek.back == 30)
    }
}

extension LinearGrowableTests.EdgeCase {

    @Test
    func `truncate to zero empties buffer`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.truncate(to: .zero)
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
    }

    @Test
    func `swap same index is no-op`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.swap(at: .init(_unchecked: Ordinal(1)), with: .init(_unchecked: Ordinal(1)))
        #expect(buffer[.init(_unchecked: Ordinal(1))] == 20)
    }

    @Test
    func `empty buffer properties`() {
        let buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
            minimumCapacity: .init(_unchecked: Cardinal(4))
        )
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        #expect(buffer.count == .init(_unchecked: Cardinal(0)))
    }

    @Test
    func `initialize at an off-discipline slot traps instead of silently desyncing header count`()
        async
    {
        await #expect(processExitsWith: .failure) {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
                minimumCapacity: .init(_unchecked: Cardinal(4))
            )
            buffer.append(1)

            buffer.initialize(at: .init(_unchecked: Ordinal(3)), to: 99)
        }
    }

    @Test
    func `move at an off-discipline slot traps instead of silently desyncing header count`() async {
        await #expect(processExitsWith: .failure) {
            var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear(
                minimumCapacity: .init(_unchecked: Cardinal(4))
            )
            buffer.append(1)
            buffer.append(2)
            buffer.append(3)

            _ = buffer.move(at: .init(_unchecked: Ordinal(0)))
        }
    }
}

extension LinearGrowableTests.Integration {

    @Test
    func `drain then reuse`() {
        var buffer = Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Int>>.Linear([
            10, 20, 30,
        ])
        buffer.drain { _ in }
        let bufferIsEmpty = buffer.isEmpty
        #expect(bufferIsEmpty)
        buffer.append(40)
        #expect(buffer.peek.front == 40)
    }
}
