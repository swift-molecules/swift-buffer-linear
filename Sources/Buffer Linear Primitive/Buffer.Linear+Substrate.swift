public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Tagged
public import Store_Initialization
public import Store_Protocol
public import Store
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
