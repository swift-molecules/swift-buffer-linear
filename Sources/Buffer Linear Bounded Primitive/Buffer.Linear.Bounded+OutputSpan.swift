import Index
public import Store
import Span
import Ownership
import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Tagged
public import Storage
public import Memory_Allocator_Protocol

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift.Error, Resource: Memory.Growable & ~Copyable>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
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
