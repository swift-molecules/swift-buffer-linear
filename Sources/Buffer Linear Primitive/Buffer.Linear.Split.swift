import Affine_Primitives_Standard_Library_Integration
import Index_Primitives
public import Store_Protocol_Primitives

extension Buffer.Linear where S: ~Copyable {

    /// Two independently owned parts of a consumed linear buffer.
    @frozen
    public struct Split: ~Copyable {
        /// The leading elements, up to the requested maximum.
        public let prefix: Buffer<S>.Linear

        /// The elements following `prefix`.
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

/// Sendable conformance for independently owned buffer parts.
extension Buffer.Linear.Split: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}
