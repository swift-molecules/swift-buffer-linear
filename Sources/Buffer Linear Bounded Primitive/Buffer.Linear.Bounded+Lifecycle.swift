import Affine_Primitives_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
public import Storage_Primitive
import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

extension Buffer.Linear.Bounded where S: ~Copyable {

    @inlinable
    public init<E: ~Copyable>(minimumCapacity: Index<E>.Count)
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        let storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
            minimumCapacity: minimumCapacity
        )
        self.init(
            header: Buffer.Linear.Header(capacity: minimumCapacity),
            storage: storage
        )
    }

    @inlinable
    public var count: Index<S.Element>.Count { header.count }

    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    @inlinable
    public var capacity: Index<S.Element>.Count { header.capacity }

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
    public mutating func truncate(to newCount: Index<S.Element>.Count) {
        Buffer.Linear.truncate(to: newCount, header: &header, storage: &storage)
    }
}

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    mutating func _removeFirst<E: ~Copyable>() -> E
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        Buffer.Linear.removeFirst(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeLast<E: ~Copyable>() -> E
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        Buffer.Linear.consumeBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll<E: ~Copyable>()
    where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
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
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Remove,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Bounded,
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
        minimumCapacity: Index<E>.Count,
        initializingCount count: Index<E>.Count,
        with body: (inout Swift.OutputSpan<E>) -> Void
    ) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(
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
