import Ordinal
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
