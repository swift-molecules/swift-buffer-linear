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
