import Index
import Store
import Span
public import Ownership
public import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal
public import Property
public import Tagged
public import Storage
public import Memory_Allocator_Protocol

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
            base.value.header.count.subtract.saturating(.one).map { Ordinal($0.rawValue) }
        ]
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E, Resource: Memory.Growable & ~Copyable>(_ elements: [E], capacity: UInt) throws(Self.Error)
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        guard elements.count <= Int(capacity) else { throw .capacityExceeded }
        var buffer = Self(minimumCapacity: .init(capacity))
        for element in elements {
            _ = buffer.append(element)
        }
        self = buffer
    }
}

// The canonical heap-backed view preserves the same element and ledger operations.
extension Property.Borrow.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Peek,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Bounded,
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
