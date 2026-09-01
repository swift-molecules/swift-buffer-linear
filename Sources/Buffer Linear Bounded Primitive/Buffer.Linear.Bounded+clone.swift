public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage_Memory

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func clone<E>() -> Self
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: header.capacity
        )
        Buffer.Linear.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Buffer.Linear.Header(capacity: header.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
