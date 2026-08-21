public import Sequence_Primitives
public import Span_Protocol_Primitives

extension Buffer.Linear: Sequenceable where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    @_implements(Sequenceable,Iterator)
    public typealias SequenceableIterator = Buffer<S>.Linear.Scalar

    @inlinable
    public consuming func makeIterator() -> Buffer<S>.Linear.Scalar {
        Buffer<S>.Linear.Scalar(self)
    }
}
