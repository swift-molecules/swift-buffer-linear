import Ordinal
import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable {

    @frozen
    public struct Bounded: ~Copyable {
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

extension Buffer.Linear.Bounded: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}
