import Index
import Tagged
import Store
import Span
import Ownership
import Ordinal
import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage
public import Memory_Allocator_Protocol

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: header.capacity
        )
        Buffer.Linear.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Buffer.Linear.Header(capacity: header.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
