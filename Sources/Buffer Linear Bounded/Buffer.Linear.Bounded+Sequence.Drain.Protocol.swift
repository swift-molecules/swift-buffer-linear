public import Sequence
public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal

extension Buffer.Linear.Bounded: Sequence.Drain.`Protocol` where S: ~Copyable {

    @inlinable
    public mutating func drain(_ body: (consuming S.Element) -> Void) {
        _drain(body)
    }
}
