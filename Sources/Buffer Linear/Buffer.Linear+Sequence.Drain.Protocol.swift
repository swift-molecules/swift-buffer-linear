import Cardinal
import Index
import Ordinal
import Ownership
public import Sequence
import Span
public import Store
import Tagged

extension Buffer.Linear: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}
