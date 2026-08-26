import Affine_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
public import Storage_Primitive
public import Storage_Protocol
public import Store_Protocol

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
