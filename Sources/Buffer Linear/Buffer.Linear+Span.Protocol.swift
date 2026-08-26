import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Span_Protocol
public import Storage_Contiguous

extension Buffer.Linear: Span.`Protocol` where S: Span.`Protocol`, S: ~Copyable {}

extension Buffer.Linear where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<S.Element>) throws(E) -> R
    ) throws(E) -> R {
        return try span.withUnsafeBufferPointer(body)
    }
}
