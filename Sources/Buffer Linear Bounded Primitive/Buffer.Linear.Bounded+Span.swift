import Index
import Tagged
public import Store
public import Span
import Ownership
import Ordinal
import Cardinal
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
