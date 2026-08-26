import Memory_Allocator_Primitive
import Memory_Heap
import Sequence
public import Span_Protocol
public import Storage_Contiguous

extension Buffer.Linear where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {
        _drain { _ in }
    }
}
