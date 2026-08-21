import Affine_Primitives_Standard_Library_Integration
import Index_Primitives
import Ordinal_Primitives_Standard_Library_Integration
import Storage_Contiguous_Primitives
import Storage_Primitive
public import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

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
