import Cardinal
import Index
public import Iterator
import Ordinal
import Ownership
public import Span
public import Store
import Tagged

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
