public import Buffer
import Cardinal
import Finite
import Index
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged

extension Buffer.Linear where S: ~Copyable {

    @frozen
    public struct Bounded: ~Copyable {
        @usableFromInline
        var header: Header

        @usableFromInline
        var storage: S

        @inlinable
        package init(header: Header, storage: consuming S) {
            self.header = header
            self.storage = storage
        }
    }
}

extension Buffer.Linear.Bounded: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

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

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    package var _storage: S {
        _read { yield storage }
    }

    @usableFromInline
    package mutating func _drain(_ body: (consuming S.Element) -> Void) {
        var position: Index<S.Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while position < end {
            body(storage.move(at: position))
            position += .one
        }
        header.count = .zero
    }
}

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

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public subscript<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(index: Index<E>) -> E
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        _read {
            yield storage[index]
        }
        _modify {
            yield &storage[index]
        }
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: header.capacity
        )
        Buffer.Linear.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Buffer.Linear.Header(capacity: header.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public func forEach<E: Swift::Error>(_ body: (borrowing S.Element) throws(E) -> Void) throws(E) {
        var slot: Index<S.Element> = .zero
        let end = header.count.map { Ordinal($0.rawValue) }
        while slot < end {
            try body(storage[slot])
            slot += .one
        }
    }
}
