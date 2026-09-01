import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Buffer
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage_Memory
import Storage

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        @Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear.Builder _ builder: ()
            -> Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>>.Linear
    ) throws(Self.Error) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
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
