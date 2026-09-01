public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Tagged
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Ordinal
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
        let n = header.count.underlying.rawValue
        var i: UInt = 0
        while i < n {
            let slot = Index<S.Element>(_unchecked: Ordinal(i))
            destination.initialize(at: slot, to: source[slot])
            i += 1
        }
    }
}
