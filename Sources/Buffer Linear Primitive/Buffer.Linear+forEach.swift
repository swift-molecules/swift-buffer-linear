public import Store
import Span
import Ownership
public import Ordinal
public import Cardinal
public import Tagged
public import Index
import Finite
import Ordinal
import Storage_Memory
import Storage

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
