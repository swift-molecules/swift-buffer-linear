public import Cardinal
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
import Ownership
import Span
public import Storage
import Store
public import Tagged

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
