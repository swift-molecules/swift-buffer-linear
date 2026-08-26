import Affine_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public mutating func reallocate<E: ~Copyable>(capacity newCapacity: Index<E>.Count)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        precondition(
            newCapacity >= header.count,
            "Buffer.Linear.reallocate(capacity:): capacity must be >= count"
        )
        _growTo(newCapacity)
    }
}
