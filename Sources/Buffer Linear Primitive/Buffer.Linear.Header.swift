import Affine_Primitives_Standard_Library_Integration
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
import Storage_Primitive
public import Store_Initialization_Primitives

extension Buffer.Linear where S: ~Copyable {

    @frozen
    public struct Header: Copyable, Sendable {

        public var count: Index<S.Element>.Count

        public let capacity: Index<S.Element>.Count

        @inlinable
        public init(capacity: Index<S.Element>.Count) {
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
    public var initialization: Store.Initialization<S.Element> { .init(self) }
}
