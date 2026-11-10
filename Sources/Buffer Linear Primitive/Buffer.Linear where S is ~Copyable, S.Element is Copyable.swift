import Cardinal
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
import Ownership
import Span
public import Storage
public import Store
import Tagged

extension Buffer.Linear where S: ~Copyable, S.Element: Copyable {

    @inlinable
    public static func copy<Resource: Memory.Growable & ~Copyable>(
        header: Header,
        source: borrowing Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>,
        to destination: inout Storage<Memory.Allocator<Resource>>.Contiguous<S.Element>
    ) {
        source.copy(to: &destination, count: header.count)
    }
}
