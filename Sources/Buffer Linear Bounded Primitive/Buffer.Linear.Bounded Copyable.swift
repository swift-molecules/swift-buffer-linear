public import Ownership
public import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Property
public import Tagged
public import Storage_Memory
public import Storage

extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear.Bounded,
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

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E>(_ elements: [E], capacity: UInt) throws(Self.Error)
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        guard elements.count <= Int(capacity) else { throw .capacityExceeded }
        var buffer = Self(minimumCapacity: .init(capacity))
        for element in elements {
            _ = buffer.append(element)
        }
        self = buffer
    }
}
