import Ordinal
import Affine_Standard_Library_Integration
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func copy(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<S.Element>
    ) {
        source.copy(to: &destination, count: header.count)
    }
}
