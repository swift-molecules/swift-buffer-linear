public import Memory_Allocator_Protocol
import Store
import Span
import Index
import Ownership
import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
import Memory_Small
import Ordinal
public import Tagged
public import Storage_Memory

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public mutating func reallocate<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        capacity newCapacity: Tagged<E, Cardinal>
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        precondition(
            newCapacity >= header.count,
            "Buffer.Linear.reallocate(capacity:): capacity must be >= count"
        )
        _growTo(newCapacity)
    }
}
