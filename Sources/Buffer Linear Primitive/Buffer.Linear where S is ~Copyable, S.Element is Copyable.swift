public import Cardinal
public import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
public import Ordinal
import Ownership
import Span
public import Storage
public import Store
public import Tagged

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
