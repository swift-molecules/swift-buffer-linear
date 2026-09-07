public import Store
public import Span
public import Index
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}
