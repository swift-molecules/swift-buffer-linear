import Affine_Primitives_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
public import Storage_Primitive
public import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

extension Buffer.Linear where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func copy(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Heap>>.Contiguous<S.Element>
    ) {
        source.copy(to: &destination, count: header.count)
    }
}
