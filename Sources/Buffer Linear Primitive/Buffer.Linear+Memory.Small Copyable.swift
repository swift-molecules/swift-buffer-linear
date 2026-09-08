public import Store
public import Span
public import Index
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal
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
