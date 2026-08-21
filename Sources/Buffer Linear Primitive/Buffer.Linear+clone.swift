import Affine_Primitives_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
public import Storage_Primitive

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func clone<E>() -> Self
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
            minimumCapacity: header.count
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }

    @inlinable
    public func clone<E>(capacity: Index<E>.Count) -> Self
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>, E: Copyable {
        precondition(
            capacity >= header.count,
            "Buffer.Linear.clone(capacity:): capacity must be >= count"
        )
        var newStorage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
