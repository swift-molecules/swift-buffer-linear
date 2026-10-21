public import Cardinal
import Index
public import Memory
public import Memory_Allocator
public import Memory_Small
public import Ordinal
public import Ownership
public import Property
import Span
public import Storage
import Store
public import Tagged

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

// The canonical heap-backed view preserves the same element and ledger operations.
extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear,
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
