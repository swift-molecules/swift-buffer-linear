import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
import Ordinal_Standard_Library_Integration
public import Tagged
import Storage_Memory
public import Storage

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
