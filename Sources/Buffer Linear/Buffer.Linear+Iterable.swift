public import Iterable
public import Memory_Iterator
public import Span_Protocol

extension Buffer.Linear: Iterable where S: Span.`Protocol`, S: ~Copyable {

    @_implements(Iterable,Iterator)
    public typealias IterableIterator = Iterator_Primitive.Iterator.Chunk<S.Element>
}
