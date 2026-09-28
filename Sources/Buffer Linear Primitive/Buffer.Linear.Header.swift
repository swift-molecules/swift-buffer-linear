public import Store
import Span
import Index
import Ownership
import Ordinal
public import Cardinal
public import Tagged
import Storage

extension Buffer.Linear where S: ~Copyable {

    @frozen
    public struct Header: Copyable, Sendable {

        public var count: Tagged<S.Element, Cardinal>

        public let capacity: Tagged<S.Element, Cardinal>

        @inlinable
        public init(capacity: Tagged<S.Element, Cardinal>) {
            self.count = .zero
            self.capacity = capacity
        }
    }
}

extension Buffer.Linear.Header where S: ~Copyable {

    @inlinable
    public var isEmpty: Bool { count == .zero }

    @inlinable
    public var isFull: Bool { count == capacity }
}

extension Buffer.Linear.Header where S: ~Copyable {

    @inlinable
    public var initialization: Store.Initialization<S.Element> { .linear(count: count) }
}
