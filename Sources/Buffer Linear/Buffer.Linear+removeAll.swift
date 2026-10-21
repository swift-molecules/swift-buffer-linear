import Cardinal
import Index
import Ordinal
import Ownership
public import Span
public import Store
import Tagged

extension Buffer.Linear where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {
        _drain { _ in }
    }
}
