import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Storage_Contiguous
import Storage_Primitive
import Storage_Protocol
public import Store_Protocol

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    package var _storage: S {
        _read { yield storage }
    }

    @usableFromInline
    package mutating func _drain(_ body: (consuming S.Element) -> Void) {
        var position: Index<S.Element> = .zero
        let end = header.count.map(Ordinal.init)
        while position < end {
            body(storage.move(at: position))
            position += .one
        }
        header.count = .zero
    }
}
