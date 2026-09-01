public import Store_Ledgered
public import Store_Operations
public import Span_Protocol
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
import Tagged
import Cardinal
public import Ordinal
import Index
import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Storage_Memory
public import Storage

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    package var _storage: S {
        _read { yield storage }
    }

    @usableFromInline
    package mutating func _drain(_ body: (consuming S.Element) -> Void) {
        var position: Index<S.Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while position < end {
            body(storage.move(at: position))
            position += .one
        }
        header.count = .zero
    }
}
