public import Memory
public import Memory_Allocator
public import Storage
public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Tagged
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
import Ordinal_Standard_Library_Integration
public import Span

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
