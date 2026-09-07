public import Sequence
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal

extension Buffer.Linear: Sequenceable where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Element = S.Element

    @_implements(Sequenceable,Iterator)
    public typealias SequenceableIterator = Buffer<S>.Linear.Scalar

    @inlinable
    @_implements(Sequenceable,makeIterator())
    public consuming func sequenceableMakeIterator() -> Buffer<S>.Linear.Scalar {
        Buffer<S>.Linear.Scalar(self)
    }
}
