import Store
import Span
import Index
import Tagged
import Ownership
import Ordinal
import Cardinal
import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}
