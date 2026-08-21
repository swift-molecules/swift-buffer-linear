import Memory_Allocator_Primitive
import Memory_Heap_Primitives
import Sequence_Primitives
public import Span_Protocol_Primitives
public import Storage_Contiguous_Primitives

extension Buffer.Linear where S: Span.`Protocol`, S: Copyable, S.Element: Copyable {

    @inlinable
    public mutating func removeAll() {
        _drain { _ in }
    }
}
