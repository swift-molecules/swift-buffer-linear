import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    @frozen
    public struct Linear: ~Copyable {

        @usableFromInline
        var header: Header

        @usableFromInline
        var storage: S

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }
    }
}

extension Buffer.Linear: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}
