import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged

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
