public import Store
import Span
public import Tagged
import Ownership
import Ordinal
import Cardinal
public import Index
import Memory
import Ordinal
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
