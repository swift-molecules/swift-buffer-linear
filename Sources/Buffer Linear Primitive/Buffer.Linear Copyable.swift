public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
public import Cardinal
public import Tagged
public import Property
public import Property_Ownership
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Storage_Memory
public import Storage

extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
    Element: Copyable
{

    @inlinable
    public var front: Element {
        base.value.storage[.zero]
    }

    @inlinable
    public var back: Element {
        return base.value.storage[
            base.value.header.count.subtract.saturating(.one).map { Ordinal($0.rawValue) }
        ]
    }
}
