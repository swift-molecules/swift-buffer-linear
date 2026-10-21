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
public import Store
public import Tagged

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift::Error, Resource: Memory.Growable & ~Copyable>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift::OutputSpan<E>) throws(Failure) -> Void
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
