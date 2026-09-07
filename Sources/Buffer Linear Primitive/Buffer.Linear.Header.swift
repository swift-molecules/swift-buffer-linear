public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
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
