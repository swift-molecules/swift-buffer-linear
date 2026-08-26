public import Index
public import Store_Protocol

extension Buffer.Linear: Store.`Protocol` where S: Store.`Protocol`, S: ~Copyable {

    @inlinable
    public mutating func initialize(at slot: Index<S.Element>, to element: consuming S.Element) {
        precondition(
            slot == header.count.map(Ordinal.init),
            "Buffer.Linear.initialize(at:to:): the contiguous discipline only appends at the trailing slot (slot == count)"
        )
        storage.initialize(at: slot, to: element)
        header.count += .one
    }

    @inlinable
    public mutating func move(at slot: Index<S.Element>) -> S.Element {
        precondition(
            header.count > .zero
                && slot == header.count.subtract.saturating(.one).map(Ordinal.init),
            "Buffer.Linear.move(at:): the contiguous discipline only retracts the trailing slot (slot == count.subtract.saturating(.one))"
        )
        let element = storage.move(at: slot)
        header.count = header.count.subtract.saturating(.one)
        return element
    }

    @inlinable
    public mutating func swapAt(_ i: Index<S.Element>, _ j: Index<S.Element>) {
        storage.swapAt(i, j)
    }
}
