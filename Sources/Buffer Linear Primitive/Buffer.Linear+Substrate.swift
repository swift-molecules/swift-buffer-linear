import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
import Store
import Tagged

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}
