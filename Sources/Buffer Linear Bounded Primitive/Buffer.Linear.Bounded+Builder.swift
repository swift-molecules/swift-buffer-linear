import Affine_Standard_Library_Integration
public import Buffer_Protocol
public import Memory_Allocator_Primitive
public import Memory_Heap
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
import Storage_Protocol

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Index<E>.Count,
        @Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear.Builder _ builder: ()
            -> Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>>.Linear
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
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
