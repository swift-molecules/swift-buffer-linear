import Cardinal
import Index
import Iterator
import Ordinal
import Ownership
public import Sequence
public import Span
public import Store
import Tagged

extension Buffer.Linear.Bounded: Sequenceable
where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    public typealias Element = S.Element

    @_implements(Sequenceable,Iterator)
    public typealias SequenceableIterator = Buffer<S>.Linear.Bounded.Scalar

    @inlinable
    @_implements(Sequenceable,makeIterator())
    public consuming func sequenceableMakeIterator() -> Buffer<S>.Linear.Bounded.Scalar {
        Buffer<S>.Linear.Bounded.Scalar(self)
    }
}
