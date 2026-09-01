public import Memory_Allocator_Protocol
public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Ordinal
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
