public import Buffer_Linear
public import Memory_Allocator_Primitive
public import Memory_Heap
public import Storage_Contiguous

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E>(_ elements: [E], minimumCapacity: UInt = 0)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        let cap: Index<E>.Count = .init(Cardinal(Swift.max(UInt(elements.count), minimumCapacity)))
        var buffer = Self(minimumCapacity: cap)
        for element in elements {
            buffer.append(element)
        }
        self = buffer
    }
}
