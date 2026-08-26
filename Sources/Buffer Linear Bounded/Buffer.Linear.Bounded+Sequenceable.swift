public import Sequence
public import Span_Protocol

extension Buffer.Linear.Bounded: Sequenceable
where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @_implements(Sequenceable,Iterator)
    public typealias SequenceableIterator = Buffer<S>.Linear.Bounded.Scalar

    @inlinable
    public consuming func makeIterator() -> Buffer<S>.Linear.Bounded.Scalar {
        Buffer<S>.Linear.Bounded.Scalar(self)
    }
}
