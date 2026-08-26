import Affine_Standard_Library_Integration
public import Finite
import Ordinal_Standard_Library_Integration
import Storage_Contiguous
public import Store_Protocol

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func forEach<E: Swift.Error>(_ body: (borrowing S.Element) throws(E) -> Void) throws(E) {
        var slot: Index<S.Element> = .zero
        let end = header.count.map(Ordinal.init)
        while slot < end {
            try body(storage[slot])
            slot += .one
        }
    }
}
