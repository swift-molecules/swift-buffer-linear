import Cardinal
public import Index
import Memory
import Ordinal
import Ownership
import Span
import Storage
public import Store
public import Tagged

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
