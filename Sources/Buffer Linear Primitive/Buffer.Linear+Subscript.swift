public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Tagged
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
public import Cardinal
public import Index
import Memory
import Ordinal_Standard_Library_Integration
import Storage_Memory

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public subscript(_ index: Index<S.Element>) -> S.Element {
        _read {
            yield storage[index]
        }
        _modify {
            yield &storage[index]
        }
    }
}
