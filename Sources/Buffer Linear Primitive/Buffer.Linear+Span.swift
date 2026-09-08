public import Memory
public import Memory_Allocator
public import Storage
public import Store
public import Span
public import Index
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
import Ordinal

extension Buffer.Linear where S: Span.`Protocol`, S: ~Copyable {

    public var span: Swift.Span<S.Element> {
        @_lifetime(borrow self)
        @inlinable
        borrowing get {
            storage.span
        }
    }
}


extension Buffer.Linear where S: ~Copyable {

    @inlinable
    @_lifetime(&self)
    public mutating func mutableSpan<E: ~Copyable, Resource: Memory.Region & ~Copyable>()
        -> Swift.MutableSpan<E>
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        storage.mutableSpan(count: header.count)
    }
}
