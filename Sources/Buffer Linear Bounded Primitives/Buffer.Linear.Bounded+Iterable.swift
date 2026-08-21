public import Iterable
public import Memory_Iterator_Primitives
public import Span_Protocol_Primitives

extension Buffer.Linear.Bounded: Iterable where S: Span.`Protocol`, S: ~Copyable {

    @_implements(Iterable,Iterator)
    public typealias IterableIterator = Iterator_Primitive.Iterator.Chunk<S.Element>
}
