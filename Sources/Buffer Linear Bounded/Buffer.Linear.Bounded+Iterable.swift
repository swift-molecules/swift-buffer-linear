public import Iterator_Chunk
public import Iterable
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
public import Iterator
public import Span

extension Buffer.Linear.Bounded: Iterable where S: Span.`Protocol`, S: ~Copyable {

    public typealias Element = S.Element

    @_implements(Iterable,Iterator)
    public typealias IterableIterator = Iterator.Chunk<S.Element>

    @inlinable
    @_lifetime(borrow self)
    @_implements(Iterable,makeIterator())
    public borrowing func iterableMakeIterator() -> Iterator.Chunk<S.Element> {
        .init(span)
    }
}
