import Cardinal
public import Index
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

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public subscript<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(index: Index<E>) -> E
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        _read {
            yield storage[index]
        }
        _modify {
            yield &storage[index]
        }
    }
}
