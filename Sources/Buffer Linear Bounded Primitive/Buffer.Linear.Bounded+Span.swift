import Affine_Primitives_Standard_Library_Integration
import Ordinal_Primitives_Standard_Library_Integration
public import Span_Protocol_Primitives

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: ~Copyable {

    public var span: Swift.Span<S.Element> {
        @_lifetime(borrow self)
        @inlinable
        borrowing get {
            storage.span
        }
    }
}

extension Buffer.Linear.Bounded where S: Span.Mutable.`Protocol`, S: ~Copyable {

    public var mutableSpan: Swift.MutableSpan<S.Element> {
        @_lifetime(&self)
        @inlinable
        mutating get {
            storage.mutableSpan(count: header.count)
        }
    }
}
