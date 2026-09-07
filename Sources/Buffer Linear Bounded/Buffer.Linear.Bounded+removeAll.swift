public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal
import Sequence

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {
        _drain { _ in }
    }
}
