public import Store
import Span
import Ownership
import Ordinal
import Cardinal
import Tagged
import Index
import Ordinal
import Storage_Memory
import Storage

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
