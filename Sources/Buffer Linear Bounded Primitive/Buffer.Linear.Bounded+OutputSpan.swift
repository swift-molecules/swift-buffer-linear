import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator_Primitive
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage_Memory
public import Storage

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift.Error>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )

        try storage.withOutputSpan(addingCapacity: capacity) { output throws(Failure) in
            try initializer(&output)
        }
        var header = Buffer.Linear.Header(capacity: capacity)
        header.count = storage.initialization.count
        self.init(header: header, storage: storage)
    }
}
