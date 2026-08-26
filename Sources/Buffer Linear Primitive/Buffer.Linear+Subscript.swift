import Affine_Standard_Library_Integration
import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

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
