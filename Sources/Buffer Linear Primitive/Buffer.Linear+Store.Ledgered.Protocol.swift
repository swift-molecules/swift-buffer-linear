public import Store
public import Span
public import Index
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
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
