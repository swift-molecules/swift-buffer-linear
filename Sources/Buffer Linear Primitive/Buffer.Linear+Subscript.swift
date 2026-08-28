import Ordinal
public import Index
import Affine_Standard_Library_Integration
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
