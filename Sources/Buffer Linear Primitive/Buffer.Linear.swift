import Affine_Standard_Library_Integration
import Index
import Ordinal_Standard_Library_Integration
import Storage_Contiguous
import Storage_Primitive
public import Storage_Protocol
public import Store_Protocol

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
