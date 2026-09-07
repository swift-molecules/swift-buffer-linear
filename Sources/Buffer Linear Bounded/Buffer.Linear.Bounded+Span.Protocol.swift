public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal

extension Buffer.Linear.Bounded: Span.`Protocol` where S: Span.`Protocol`, S: ~Copyable {}

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    @inlinable
    public func withUnsafeBufferPointer<R, E: Swift.Error>(
        _ body: (UnsafeBufferPointer<S.Element>) throws(E) -> R
    ) throws(E) -> R {
        return try span.withUnsafeBufferPointer(body)
    }
}
