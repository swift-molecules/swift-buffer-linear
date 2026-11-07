import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged
public import Memory
public import Memory_Allocator
public import Memory_Allocator_Protocol
import Memory_Small
import Finite

extension Buffer where S: Store.`Protocol`, S: ~Copyable {

    @frozen
    public struct Linear: ~Copyable {

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

extension Buffer.Linear: @unsafe @unchecked Sendable
where S: Store.`Protocol` & ~Copyable & Sendable {}

extension Buffer.Linear where S: ~Copyable {

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

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public static func append(
        _ element: consuming S.Element,
        header: inout Header,
        storage: inout S
    ) {
        S.linearAppend(consume element, count: &header.count, storage: &storage)
    }

    @inlinable
    public static func removeFirst(
        header: inout Header,
        storage: inout S
    ) -> S.Element {
        S.linearRemoveFirst(count: &header.count, storage: &storage)
    }

    @inlinable
    public static func remove(
        at index: Index<S.Element>,
        header: inout Header,
        storage: inout S
    ) -> S.Element {
        S.linearRemove(at: index, count: &header.count, storage: &storage)
    }

    @inlinable
    public static func replace(
        at index: Index<S.Element>,
        with newElement: consuming S.Element,
        storage: inout S
    ) -> S.Element {
        S.linearReplace(at: index, with: consume newElement, storage: &storage)
    }

    @inlinable
    public static func consumeBack(
        header: inout Header,
        storage: inout S
    ) -> S.Element {
        S.linearConsumeBack(count: &header.count, storage: &storage)
    }

    @inlinable
    public static func swap(
        at i: Index<S.Element>,
        with j: Index<S.Element>,
        storage: inout S
    ) {
        S.linearSwap(at: i, with: j, storage: &storage)
    }

    @inlinable
    public static func deinitializeAll(
        header: inout Header,
        storage: inout S
    ) {
        S.linearDeinitializeAll(count: &header.count, storage: &storage)
    }

    @inlinable
    public static func truncate(
        to newCount: Tagged<S.Element, Cardinal>,
        header: inout Header,
        storage: inout S
    ) {
        S.linearTruncate(to: newCount, count: &header.count, storage: &storage)
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable, Failure: Swift::Error, Resource: Memory.Growable & ~Copyable>(
        capacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift::OutputSpan<E>) throws(Failure) -> Void
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
    public mutating func edit<E: ~Copyable, Failure: Swift::Error, R: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ body: (inout Swift::OutputSpan<E>) throws(Failure) -> R
    ) throws(Failure) -> R where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {

        storage.initialization = header.initialization
        defer { header.count = storage.initialization.count }
        return try body(&storage.outputSpan)
    }

    @inlinable
    public mutating func append<E: ~Copyable, Failure: Swift::Error, Resource: Memory.Growable & ~Copyable>(
        addingCapacity: Tagged<E, Cardinal>,
        initializingWith initializer: (inout Swift::OutputSpan<E>) throws(Failure) -> Void
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

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public subscript(_ index: Index<S.Element>) -> S.Element {
        _read {
            yield storage[index]
        }
        _modify {
            yield &storage[index]
        }
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public var substrate: S {
        _read { yield storage }
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>() -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: header.count
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }

    @inlinable
    public func clone<E, Resource: Memory.Growable & ~Copyable>(capacity: Tagged<E, Cardinal>) -> Self
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<E>, E: Copyable {
        precondition(
            capacity >= header.count,
            "Buffer.Linear.clone(capacity:): capacity must be >= count"
        )
        var newStorage = Storage<Memory.Allocator<Resource>>.Contiguous<E>.create(
            minimumCapacity: capacity
        )
        Self.copy(header: header, source: storage, to: &newStorage)
        var newHeader = Self.Header(capacity: newStorage.capacity)
        newHeader.count = header.count
        newStorage.initialization = newHeader.initialization
        return Self(header: newHeader, storage: newStorage)
    }
}

extension Buffer.Linear where S: ~Copyable {

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

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public mutating func reallocate<E: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        capacity newCapacity: Tagged<E, Cardinal>
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<E> {
        precondition(
            newCapacity >= header.count,
            "Buffer.Linear.reallocate(capacity:): capacity must be >= count"
        )
        _growTo(newCapacity)
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public consuming func split<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        maximum: Tagged<Element, Cardinal>
    ) -> Split where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        var source = consume self
        let prefixCount = maximum < source.header.count ? maximum : source.header.count
        let remainderCount = source.header.count.subtract.saturating(prefixCount)
        var prefixStorage = S.create(minimumCapacity: prefixCount)
        var remainderStorage = S.create(minimumCapacity: remainderCount)

        var sourceSlot: Index<Element> = .zero
        let prefixEnd = prefixCount.map { Ordinal($0.rawValue) }
        while sourceSlot < prefixEnd {
            prefixStorage.initialize(at: sourceSlot, to: source.storage.move(at: sourceSlot))
            sourceSlot += Tagged<Element, Cardinal>.one
        }

        var remainderSlot: Index<Element> = .zero
        let sourceEnd = source.header.count.map { Ordinal($0.rawValue) }
        while sourceSlot < sourceEnd {
            remainderStorage.initialize(
                at: remainderSlot,
                to: source.storage.move(at: sourceSlot)
            )
            sourceSlot += Tagged<Element, Cardinal>.one
            remainderSlot += Tagged<Element, Cardinal>.one
        }

        var prefixHeader = Self.Header(capacity: prefixStorage.capacity)
        prefixHeader.count = prefixCount
        var remainderHeader = Self.Header(capacity: remainderStorage.capacity)
        remainderHeader.count = remainderCount
        return Split(
            prefix: Self(header: prefixHeader, storage: prefixStorage),
            remainder: Self(header: remainderHeader, storage: remainderStorage)
        )
    }
}
