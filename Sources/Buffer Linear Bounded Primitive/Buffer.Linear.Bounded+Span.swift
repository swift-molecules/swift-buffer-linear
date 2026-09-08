public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal
import Ordinal

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: ~Copyable {

    public var span: Swift.Span<S.Element> {
        @_lifetime(borrow self)
        @inlinable
        borrowing get {
            storage.span
        }
    }
}
