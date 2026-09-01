public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Tagged
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Cardinal_Tagged
public import Cardinal_Carrier
import Affine_Standard_Library_Integration
import Index
public import Storage

extension Buffer.Linear where S: ~Copyable {

    @frozen
    public struct Split: ~Copyable {

        public let prefix: Buffer<S>.Linear

        public let remainder: Buffer<S>.Linear

        @inlinable
        package init(
            prefix: consuming Buffer<S>.Linear,
            remainder: consuming Buffer<S>.Linear
        ) {
            self.prefix = prefix
            self.remainder = remainder
        }
    }
}

extension Buffer.Linear.Split: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}
