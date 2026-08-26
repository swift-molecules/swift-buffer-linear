public import Memory_Allocator_Primitive
public import Memory_Heap
public import Storage_Contiguous

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func clone<E>() -> Self
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
            minimumCapacity: header.capacity
        )
        Buffer.Linear.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Buffer.Linear.Header(capacity: header.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
