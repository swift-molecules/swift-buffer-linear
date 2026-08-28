import Tagged
import Cardinal
import Ordinal
import Index
import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable {

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
