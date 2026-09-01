public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Tagged
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
public import Storage

extension Buffer.Linear: Store.Ledgered.`Protocol`
where S: Store.Ledgered.`Protocol`, S: ~Copyable {

    @inlinable
    public var initialization: Store.Initialization<S.Element> {
        get { .linear(count: header.count) }
        set {
            precondition(
                newValue.isPrefixShaped,
                "Buffer.Linear only represents prefix-shaped initialization"
            )
            storage.initialization = newValue
            header.count = newValue.count
        }
    }
}
