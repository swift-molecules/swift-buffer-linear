public import Iterator_Protocol
public import Sequence_Protocol
public import Index
public import Tagged
public import Store_Ledgered
public import Store_Operations
public import Span_Protocol
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
public import Cardinal
public import Sequence
public import Span

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
