public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Tagged
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
public import Cardinal
import Index
import Ordinal_Standard_Library_Integration
import Storage_Memory
public import Storage

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
