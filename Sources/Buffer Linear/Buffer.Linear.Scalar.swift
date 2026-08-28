public import Tagged
public import Cardinal
public import Ordinal
public import Index
import Affine_Standard_Library_Integration
public import Iterator
import Ordinal_Standard_Library_Integration
public import Span

extension Buffer.Linear where S: Span.`Protocol`, S: ~Copyable, S.Element: Copyable {

    public struct Scalar: Iterating<S.Element, Never>, ~Copyable {
        @_implements(Iterating,Element)
        public typealias ScalarElement = S.Element

        @_implements(Iterating,Failure)
        public typealias ScalarFailure = Never

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

    @inlinable
    public mutating func next() -> S.Element? {
        let end = base.count.map { Ordinal($0.rawValue) }
        guard position < end else { return nil }
        defer { position = position.advanced(by: .one) }

        return base[position]
    }
}
