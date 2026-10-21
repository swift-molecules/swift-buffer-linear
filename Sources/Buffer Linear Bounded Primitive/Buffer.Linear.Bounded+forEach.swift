public import Cardinal
import Finite
public import Index
public import Ordinal
import Ownership
import Span
import Storage
public import Store
public import Tagged

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func forEach<E: Swift::Error>(_ body: (borrowing S.Element) throws(E) -> Void) throws(E) {
        var slot: Index<S.Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            try body(storage[slot])
            slot += .one
        }
    }
}
