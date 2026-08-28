public import Tagged
public import Cardinal
public import Ordinal
public import Index
public import Storage

extension Buffer.Linear: Store.`Protocol` where S: Store.`Protocol`, S: ~Copyable {

    @inlinable
    public mutating func initialize(at slot: Index<S.Element>, to element: consuming S.Element) {
        precondition(
            slot == header.count.map { Ordinal($0.rawValue) },
            "Buffer.Linear.initialize(at:to:): the contiguous discipline only appends at the trailing slot (slot == count)"
        )
        storage.initialize(at: slot, to: element)
        header.count = header.count + .one
    }

    @inlinable
    public mutating func move(at slot: Index<S.Element>) -> S.Element {
        precondition(
            header.count > .zero
                && slot == header.count.subtracting(saturating: .one).map { Ordinal($0.rawValue) },
            "Buffer.Linear.move(at:): the contiguous discipline only retracts the trailing slot (slot == count.subtracting(saturating: .one))"
        )
        let element = storage.move(at: slot)
        header.count = header.count.subtracting(saturating: .one)
        return element
    }

    @inlinable
    public mutating func swapAt(_ i: Index<S.Element>, _ j: Index<S.Element>) {
        storage.swapAt(i, j)
    }
}
