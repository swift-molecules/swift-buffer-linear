import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged

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
