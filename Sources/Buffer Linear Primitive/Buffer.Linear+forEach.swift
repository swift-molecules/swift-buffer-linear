public import Tagged
public import Cardinal
public import Ordinal
public import Index
import Affine_Standard_Library_Integration
import Finite
import Ordinal_Standard_Library_Integration
import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func forEach<E: Swift.Error>(_ body: (borrowing S.Element) throws(E) -> Void) throws(E) {
        var slot: Index<S.Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            try body(storage[slot])
            slot += .one
        }
    }
}
