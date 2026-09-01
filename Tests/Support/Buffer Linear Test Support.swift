public import Buffer_Linear
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage_Memory
public import Tagged

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E>(_ elements: [E], minimumCapacity: UInt = 0)
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        let cap: Tagged<E, Cardinal> = .init(Swift.max(UInt(elements.count), minimumCapacity))
        var buffer = Self(minimumCapacity: cap)
        for element in elements {
            buffer.append(element)
        }
        self = buffer
    }
}
