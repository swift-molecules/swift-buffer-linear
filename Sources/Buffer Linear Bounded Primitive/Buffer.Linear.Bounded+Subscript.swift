import Ordinal
public import Index
import Affine_Standard_Library_Integration
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Storage_Memory

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public subscript<E: ~Copyable>(index: Index<E>) -> E
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        _read {
            yield storage[index]
        }
        _modify {
            yield &storage[index]
        }
    }
}
