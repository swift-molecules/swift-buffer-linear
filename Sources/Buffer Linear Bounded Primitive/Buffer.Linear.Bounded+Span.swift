import Cardinal
import Index
public import Memory
public import Memory_Allocator
import Ordinal
import Ownership
public import Span
public import Storage
public import Store
import Tagged

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: ~Copyable {

    public var span: Swift::Span<S.Element> {
        @_lifetime(borrow self)
        @inlinable
        borrowing get {
            storage.span
        }
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    @_lifetime(&self)
    public mutating func mutableSpan<E: ~Copyable, Resource: Memory.Region & ~Copyable>()
        -> Swift::MutableSpan<E>
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        storage.mutableSpan(count: header.count)
    }
}
