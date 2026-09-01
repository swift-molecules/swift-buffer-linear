import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage_Memory

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public mutating func reallocate<E: ~Copyable>(capacity newCapacity: Tagged<E, Cardinal>)
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        precondition(
            newCapacity >= header.count,
            "Buffer.Linear.reallocate(capacity:): capacity must be >= count"
        )
        _growTo(newCapacity)
    }
}
