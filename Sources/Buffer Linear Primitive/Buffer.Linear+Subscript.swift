public import Store
public import Span
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
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
