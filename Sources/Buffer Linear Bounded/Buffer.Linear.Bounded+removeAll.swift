import Index
import Tagged
public import Store
public import Span
import Ownership
import Ordinal
import Cardinal
import Sequence

extension Buffer.Linear.Bounded where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {
        _drain { _ in }
    }
}
