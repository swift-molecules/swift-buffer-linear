public import Ownership
import Ordinal
public import Index
import Affine_Standard_Library_Integration
public import Cardinal
public import Memory_Allocator
public import Memory
public import Memory_Small
import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Property
public import Tagged
public import Storage_Memory
public import Storage

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(minimumCapacity: Tagged<E, Cardinal>)
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        let storage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: minimumCapacity
        )
        self.init(
            header: Buffer.Linear.Header(capacity: minimumCapacity),
            storage: storage
        )
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
    public mutating func append(_ element: consuming S.Element) -> S.Element? {
        if header.isFull {
            return element
        }
        Buffer.Linear.append(consume element, header: &header, storage: &storage)
        return nil
    }

    @inlinable
    public mutating func remove(at index: Index<S.Element>) -> S.Element {
        Buffer.Linear.remove(at: index, header: &header, storage: &storage)
    }

    @inlinable
    public mutating func replace(
        at index: Index<S.Element>,
        with newElement: consuming S.Element
    ) -> S.Element {
        Buffer.Linear.replace(at: index, with: consume newElement, storage: &storage)
    }

    @inlinable
    public mutating func swap(at i: Index<S.Element>, with j: Index<S.Element>) {
        Buffer.Linear.swap(at: i, with: j, storage: &storage)
    }

    @inlinable
    public mutating func truncate(to newCount: Tagged<S.Element, Cardinal>) {
        Buffer.Linear.truncate(to: newCount, header: &header, storage: &storage)
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    mutating func _removeFirst<E: ~Copyable>() -> E
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        Buffer.Linear.removeFirst(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeLast<E: ~Copyable>() -> E
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        Buffer.Linear.consumeBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll<E: ~Copyable>()
    where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        Buffer.Linear.deinitializeAll(header: &header, storage: &storage)
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

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
    Base == Buffer<Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<Element>>.Linear.Bounded,
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

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Tagged<E, Cardinal>,
        initializingCount count: Tagged<E, Cardinal>,
        with body: (inout Swift.OutputSpan<E>) -> Void
    ) where S == Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Small<0>>>.Contiguous<E>.create(
            minimumCapacity: minimumCapacity
        )

        storage.withOutputSpan(addingCapacity: minimumCapacity) { output in
            body(&output)
        }
        var header = Buffer.Linear.Header(capacity: minimumCapacity)
        header.count = storage.initialization.count
        self.init(header: header, storage: storage)
    }
}
