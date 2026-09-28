public import Store
import Span
public import Index
public import Tagged
import Ownership
public import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal
public import Storage
public import Memory_Allocator_Protocol

extension Buffer.Linear where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func copy<Resource: Memory.Growable & ~Copyable>(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>
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
