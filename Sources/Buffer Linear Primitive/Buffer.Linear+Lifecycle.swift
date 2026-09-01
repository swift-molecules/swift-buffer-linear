public import Ownership
public import Ordinal
public import Index
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory_Allocator_Protocol
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Property
public import Tagged
public import Storage_Memory
public import Storage

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        minimumCapacity: Tagged<Element, Cardinal>
    ) where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        let storage = S.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Self.Header(capacity: storage.capacity),
            storage: storage
        )
    }

    @inlinable
    public init<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>()
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        self.init(minimumCapacity: Tagged<Element, Cardinal>.zero)
    }

    @inlinable
    public var count: Tagged<S.Element, Cardinal> { header.count }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var capacity: Tagged<S.Element, Cardinal> { header.capacity }

    @inlinable
    public var isFull: Bool { header.isFull }

    @inlinable
    public mutating func append<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ element: consuming Element
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if header.isFull {
            let newCapacity: Tagged<Element, Cardinal> =
                header.capacity == .zero
                ? .one
                : header.capacity.adding(saturating: header.capacity)
            _growTo(newCapacity)
        }
        Self.append(consume element, header: &header, storage: &storage)
    }

    @inlinable
    public mutating func remove(at index: Index<S.Element>) -> S.Element {
        Self.remove(at: index, header: &header, storage: &storage)
    }

    @inlinable
    public mutating func replace(
        at index: Index<S.Element>,
        with newElement: consuming S.Element
    ) -> S.Element {
        Self.replace(at: index, with: consume newElement, storage: &storage)
    }

    @inlinable
    public mutating func swap(at i: Index<S.Element>, with j: Index<S.Element>) {
        Self.swap(at: i, with: j, storage: &storage)
    }

    @inlinable
    public mutating func truncate(to newCount: Tagged<S.Element, Cardinal>) {
        Self.truncate(to: newCount, header: &header, storage: &storage)
    }

    @inlinable
    public mutating func removeFirst() -> S.Element {
        _removeFirst()
    }

    @inlinable
    public mutating func removeLast() -> S.Element {
        _removeLast()
    }

    @inlinable
    public mutating func removeAll() {
        _removeAll()
    }

    @inlinable
    public mutating func removeAll<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        keepingCapacity: Bool
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        _removeAll()
        if !keepingCapacity {
            self = Buffer.Linear(minimumCapacity: Tagged<Element, Cardinal>.zero)
        }
    }

    @inlinable
    public mutating func reserveCapacity<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Tagged<Element, Cardinal>
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        if minimumCapacity > header.capacity {
            _growTo(minimumCapacity)
        }
    }

    @inlinable
    package mutating func _growTo<Element: ~Copyable, Resource: Memory.Growable & ~Copyable>(
        _ minimumCapacity: Tagged<Element, Cardinal>
    )
    where S == Storage<Memory.Allocator<Resource>>.Contiguous<Element> {
        var newStorage = S.create(minimumCapacity: minimumCapacity)
        let newCapacity = newStorage.capacity
        let oldCount = header.count

        var slot: Index<Element> = .zero
        let end = oldCount.map { Ordinal($0.rawValue) }
        while slot < end {
            newStorage.initialize(at: slot, to: storage.move(at: slot))
            slot += .one
        }
        storage = newStorage
        header = Self.Header(capacity: newCapacity)
        header.count = oldCount
    }
}

extension Buffer.Linear where S: ~Copyable {

    @usableFromInline
    mutating func _removeFirst() -> S.Element {
        Self.removeFirst(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeLast() -> S.Element {
        Self.consumeBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll() {
        Self.deinitializeAll(header: &header, storage: &storage)
    }
}

extension Buffer.Linear where S: ~Copyable {

    @inlinable
    public var peek: Peek.View {
        _read {
            yield Peek.View(self)
        }
    }

    @inlinable
    public var remove: Remove.View {
        mutating _read {
            yield.init(&self)
        }
        mutating _modify {
            var view: Remove.View = .init(&self)
            yield &view
        }
    }
}

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear.Remove,
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear,
    Element: ~Copyable
{

    @inlinable
    public mutating func first() -> Element {
        base.value._removeFirst()
    }

    @inlinable
    public mutating func last() -> Element {
        base.value._removeLast()
    }

    @inlinable
    public mutating func all() {
        base.value._removeAll()
    }
}
