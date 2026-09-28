public import Store
import Span
import Index
import Ownership
import Ordinal
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage
public import Tagged
public import Memory_Allocator_Protocol

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift.Error, Resource: Memory.Growable & ~Copyable>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )

        try initializer(&storage.outputSpan)
        var header = Self.Header(capacity: storage.capacity)
        header.count = storage.initialization.count
        self.init(header: header, storage: storage)
    }

    @inlinable
    public mutating func edit<E: ~Copyable, Failure: Swift.Error, R: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ body: (inout Swift.OutputSpan<E>) throws(Failure) -> R
    ) throws(Failure) -> R where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        return try body(&storage.outputSpan)
    }

    @inlinable
    public mutating func append<E: ~Copyable, Failure: Swift.Error, Resource: Memory.Growable & ~Copyable>(
        addingCapacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        let required = header.count.add.saturating(addingCapacity)
        if required > header.capacity {
            _growTo(required)
        }

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        try storage.withOutputSpan(addingCapacity: addingCapacity, initializer)
    }
}
