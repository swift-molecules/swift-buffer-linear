public import Memory_Allocator_Primitive
public import Memory_Heap
public import Storage_Contiguous
public import Storage_Primitive
import Storage_Protocol

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift.Error>(
        capacity: Index<E>.Count,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )

        try initializer(&storage.outputSpan)
        var header = Self.Header(capacity: storage.capacity)
        header.count = storage.initialization.count
        self.init(header: header, storage: storage)
    }

    @inlinable
    public mutating func edit<E: ~Copyable, Failure: Swift.Error, R: ~Copyable>(
        _ body: (inout Swift.OutputSpan<E>) throws(Failure) -> R
    ) throws(Failure) -> R where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        return try body(&storage.outputSpan)
    }

    @inlinable
    public mutating func append<E: ~Copyable, Failure: Swift.Error>(
        addingCapacity: Index<E>.Count,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        let required = header.count.add.saturating(addingCapacity)
        if required > header.capacity {
            _growTo(required)
        }

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        try storage.withOutputSpan(addingCapacity: addingCapacity, initializer)
    }
}
