public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
public import Storage_Memory
public import Storage
public import Tagged

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift.Error>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
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
    ) throws(Failure) -> R where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        return try body(&storage.outputSpan)
    }

    @inlinable
    public mutating func append<E: ~Copyable, Failure: Swift.Error>(
        addingCapacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift.OutputSpan<E>) throws(Failure) -> Void
    ) throws(Failure) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        let required = header.count.adding(saturating: addingCapacity)
        if required > header.capacity {
            _growTo(required)
        }

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        try storage.withOutputSpan(addingCapacity: addingCapacity, initializer)
    }
}
