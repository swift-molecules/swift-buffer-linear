public import Sequence
import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal
import Cardinal

extension Buffer.Linear: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}
