public import Iterator
import Index
import Tagged
public import Store
public import Span
import Ownership
import Ordinal
import Cardinal

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
