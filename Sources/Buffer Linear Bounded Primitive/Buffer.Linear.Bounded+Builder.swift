public import Buffer
public import Cardinal
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
import Ownership
import Span
public import Storage
import Store
public import Tagged

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        @Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear.Builder _ builder: ()
            -> Buffer<Storage<Memory.Allocator<Resource>>.Contiguous<E>>.Linear
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        var dynamic = builder()
        guard dynamic.count <= minimumCapacity else {
            throw .capacityExceeded
        }
        self.init(minimumCapacity: minimumCapacity)
        while !dynamic.isEmpty {
            _ = self.append(dynamic.remove.first())
        }
    }
}
