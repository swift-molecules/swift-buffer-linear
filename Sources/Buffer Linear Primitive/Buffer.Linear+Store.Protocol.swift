public import Store_Operations
public import Store_Ledgered
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
                && slot == header.count.subtract.saturating(.one).map { Ordinal($0.rawValue) },
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
