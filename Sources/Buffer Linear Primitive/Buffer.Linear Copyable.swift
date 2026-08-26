import Affine_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
public import Storage_Primitive

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
            base.value.header.count.subtract.saturating(.one).map(Ordinal.init)
        ]
    }
}
