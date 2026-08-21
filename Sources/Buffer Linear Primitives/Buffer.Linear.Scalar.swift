import Affine_Primitives_Standard_Library_Integration
public import Iterable
public import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Span_Protocol_Primitives
public import Storage_Contiguous_Primitives

extension Buffer.Linear where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public struct Scalar: Iterator_Primitive.Iterator.`Protocol`, ~Copyable {
        @usableFromInline
        var base: Buffer<S>.Linear

        @usableFromInline
        var position: Index<S.Element>

        @inlinable
        package init(_ base: consuming Buffer<S>.Linear) {
            self.base = base
            self.position = .zero
        }
    }
}

extension Buffer.Linear.Scalar where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public typealias Failure = Never

    @inlinable
    public mutating func next() -> S.Element? {
        let end = base.count.map(Ordinal.init)
        guard position < end else { return nil }
        defer { position += .one }

        return base[position]
    }
}
