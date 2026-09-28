import Store
import Span
import Index
import Ownership
import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Tagged
public import Storage
public import Memory_Allocator_Protocol

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: header.count
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>(capacity: Tagged<E, Cardinal>) -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        precondition(
            capacity >= header.count,
            "Buffer.Linear.clone(capacity:): capacity must be >= count"
        )
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
