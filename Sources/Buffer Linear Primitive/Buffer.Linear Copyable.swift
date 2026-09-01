public import Ownership
public import Tagged
public import Cardinal
public import Property
public import Property_Ownership
public import Ordinal
import Affine_Standard_Library_Integration
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
            base.value.header.count.subtracting(saturating: .one).map { Ordinal($0.rawValue) }
        ]
    }
}
