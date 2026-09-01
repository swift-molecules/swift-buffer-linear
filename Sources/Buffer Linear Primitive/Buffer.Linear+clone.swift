import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func clone<E>() -> Self
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: header.count
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }

    @inlinable
    public func clone<E>(capacity: Tagged<E, Cardinal>) -> Self
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>, E: Copyable {
        precondition(
            capacity >= header.count,
            "Buffer.Linear.clone(capacity:): capacity must be >= count"
        )
        var newStorage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}
