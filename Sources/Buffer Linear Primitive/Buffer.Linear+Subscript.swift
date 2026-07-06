import Affine_Primitives_Standard_Library_Integration
import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives

extension Buffer.Linear where S: ~Copyable {
    /// Accesses the element at the given index.
    ///
    /// - Parameter index: The index of the element to access.
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
