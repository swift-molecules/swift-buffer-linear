public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
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
public import Index
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage_Memory
import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public consuming func split<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        maximum: Tagged<Element, Cardinal>
    ) -> Split where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        var source = consume self
        let prefixCount = maximum < source.header.count ? maximum : source.header.count
        let remainderCount = source.header.count.subtract.saturating(prefixCount)
        var prefixStorage = S.create(minimumCapacity: prefixCount)
        var remainderStorage = S.create(minimumCapacity: remainderCount)

        var sourceSlot: Index<Element> = .zero
        let prefixEnd = prefixCount.map { Ordinal($0.rawValue) }
        while sourceSlot < prefixEnd {
            prefixStorage.initialize(at: sourceSlot, to: source.storage.move(at: sourceSlot))
            sourceSlot += .one
        }

        var remainderSlot: Index<Element> = .zero
        let sourceEnd = source.header.count.map { Ordinal($0.rawValue) }
        while sourceSlot < sourceEnd {
            remainderStorage.initialize(
                at: remainderSlot,
                to: source.storage.move(at: sourceSlot)
            )
            sourceSlot += .one
            remainderSlot += .one
        }

        var prefixHeader = Self.Header(capacity: prefixStorage.capacity)
        prefixHeader.count = prefixCount
        var remainderHeader = Self.Header(capacity: remainderStorage.capacity)
        remainderHeader.count = remainderCount
        return Split(
            prefix: Self(header: prefixHeader, storage: prefixStorage),
            remainder: Self(header: remainderHeader, storage: remainderStorage)
        )
    }
}
