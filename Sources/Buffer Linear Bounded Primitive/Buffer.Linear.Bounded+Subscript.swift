public import Tagged
import Store
import Span
import Ownership
import Ordinal
import Cardinal
public import Index
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage
public import Memory_Allocator_Protocol

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
