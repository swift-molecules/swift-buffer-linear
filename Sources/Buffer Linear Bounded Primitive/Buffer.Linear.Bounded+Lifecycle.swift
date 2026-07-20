import Affine_Primitives_Standard_Library_Integration
public import Memory_Allocator_Primitive
public import Memory_Heap_Primitives
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
public import Storage_Primitive
import Storage_Protocol_Primitives
public import Store_Protocol_Primitives

// MARK: - Extensions for Linear.Bounded (declared in Core)

extension Buffer.Linear.Bounded where S: ~Copyable {

    /// Creates a bounded linear buffer with at least the given capacity.
    ///
    /// The header pins the CALLER-REQUESTED `minimumCapacity` as the logical capacity ceiling —
    /// fable-448/F-001: a bounded buffer's capacity IS its contract (unlike the growable buffer,
    /// whose capacity is elastic headroom), so it must be deterministic and independent of
    /// whatever `storage.capacity` the allocator happens to return. This mirrors the already-
    /// ratified `clone()` precedent (`Buffer.Linear.Bounded+clone.swift`), which pins the ORIGINAL
    /// capacity rather than the fresh storage's; any extra physical slots the allocator provides
    /// stay unused and untracked.
    @inlinable
    public init<E: ~Copyable>(minimumCapacity: Index<E>.Count) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        let storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(minimumCapacity: minimumCapacity)
        self.init(
            header: Buffer.Linear.Header(capacity: minimumCapacity),
            storage: storage
        )
    }

    /// The number of elements in the buffer.
    @inlinable
    public var count: Index<S.Element>.Count { header.count }

    /// Whether the buffer has no elements.
    @inlinable
    public var isEmpty: Bool { header.isEmpty }

    /// The total slot capacity.
    @inlinable
    public var capacity: Index<S.Element>.Count { header.capacity }

    /// Whether the buffer is at capacity.
    @inlinable
    public var isFull: Bool { header.isFull }

    // MARK: - Mutations

    /// Appends an element to the back.
    ///
    /// Returns the element if the buffer is full.
    @inlinable
    public mutating func append(_ element: consuming S.Element) -> S.Element? {
        if header.isFull {
            return element
        }
        Buffer.Linear.append(consume element, header: &header, storage: &storage)
        return nil
    }

    /// Removes and returns the element at the given index, shifting subsequent elements left.
    ///
    /// - Precondition: The index must be in bounds.
    @inlinable
    public mutating func remove(at index: Index<S.Element>) -> S.Element {
        Buffer.Linear.remove(at: index, header: &header, storage: &storage)
    }

    /// Replaces the element at the given index, returning the old element.
    ///
    /// - Precondition: The index must be in bounds.
    @inlinable
    public mutating func replace(at index: Index<S.Element>, with newElement: consuming S.Element) -> S.Element {
        Buffer.Linear.replace(at: index, with: consume newElement, storage: &storage)
    }

    /// Swaps the elements at positions `i` and `j` in-place.
    ///
    /// - Precondition: Both indices must be in bounds.
    @inlinable
    public mutating func swap(at i: Index<S.Element>, with j: Index<S.Element>) {
        Buffer.Linear.swap(at: i, with: j, storage: &storage)
    }

    /// Removes elements beyond the specified count.
    ///
    /// If `newCount >= count`, this method has no effect.
    @inlinable
    public mutating func truncate(to newCount: Index<S.Element>.Count) {
        Buffer.Linear.truncate(to: newCount, header: &header, storage: &storage)
    }
}

// MARK: - Internal Mutations

extension Buffer.Linear.Bounded where S: ~Copyable {

    @usableFromInline
    mutating func _removeFirst<E: ~Copyable>() -> E where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        Buffer.Linear.removeFirst(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeLast<E: ~Copyable>() -> E where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        Buffer.Linear.consumeBack(header: &header, storage: &storage)
    }

    @usableFromInline
    mutating func _removeAll<E: ~Copyable>() where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        Buffer.Linear.deinitializeAll(header: &header, storage: &storage)
    }
}

// MARK: - Property.Inout (.peek, .remove)

extension Buffer.Linear.Bounded where S: ~Copyable {
    /// A borrowing accessor for the front and back elements without removing them.
    @inlinable
    public var peek: Peek.View {
        _read {
            yield Peek.View(self)
        }
    }

    /// A mutating accessor that removes and returns elements.
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

// MARK: - Remove Operations (~Copyable)

extension Property.Inout.Typed
where
    Tag == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Remove,
    Base == Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Element>>.Linear.Bounded,
    Element: ~Copyable
{
    /// Removes and returns the first element, shifting remaining elements left.
    ///
    /// - Precondition: The buffer is not empty.
    @inlinable
    public mutating func first() -> Element {
        base.value._removeFirst()
    }

    /// Removes and returns the last element.
    ///
    /// - Precondition: The buffer is not empty.
    @inlinable
    public mutating func last() -> Element {
        base.value._removeLast()
    }

    /// Removes all elements from the buffer.
    @inlinable
    public mutating func all() {
        base.value._removeAll()
    }
}

// MARK: - OutputSpan-Based Initialization

extension Buffer.Linear.Bounded where S: ~Copyable {
    /// Creates a bounded linear buffer with pre-initialized elements.
    ///
    /// The closure receives an `OutputSpan<Element>` over `minimumCapacity`
    /// uninitialized tail slots and appends its elements; the buffer's count
    /// reflects however many the closure committed. Span-first replacement for
    /// the former raw-`UnsafeMutablePointer` closure (de-pointer OVERRIDING
    /// PRINCIPLE).
    ///
    /// - Note: `count` is presently unused by this initializer (the span is
    ///   windowed to `minimumCapacity`, not `count`); this pre-existing
    ///   mismatch between the parameter and the implementation is out of scope
    ///   for the fable-448/F-001 capacity-pinning fix and is tracked separately.
    ///
    /// - Parameters:
    ///   - minimumCapacity: The minimum number of slots to allocate.
    ///   - count: The number of uninitialized tail slots the closure may fill.
    ///   - body: A closure that appends elements into the provided `OutputSpan`.
    @inlinable
    public init<E: ~Copyable>(
        minimumCapacity: Index<E>.Count,
        initializingCount count: Index<E>.Count,
        with body: (inout Swift.OutputSpan<E>) -> Void
    ) where S == Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E> {
        var storage = Storage<Memory.Allocator<Memory.Heap>>.Contiguous<E>.create(minimumCapacity: minimumCapacity)
        // Windowed OutputSpan over exactly the CALLER-REQUESTED `minimumCapacity` — fable-448/F-001:
        // the header below pins `minimumCapacity` (not `storage.capacity`) as the capacity ceiling,
        // so the closure must be structurally incapable of committing more than that many elements,
        // even if a future allocator rounds `storage.capacity` up beyond what was requested.
        // `withOutputSpan(addingCapacity:)` (the same windowed seam the growable `Buffer.Linear`
        // uses) enforces this by construction: its span's `capacity` is exactly the budget passed
        // in, so `header.count <= header.capacity` can never break, without a separate runtime
        // check. This mirrors the `clone()` precedent (`Buffer.Linear.Bounded+clone.swift:33-35`)
        // of pinning the header to the REQUESTED bound rather than whatever the storage yields.
        storage.withOutputSpan(addingCapacity: minimumCapacity) { output in
            body(&output)
        }
        var header = Buffer.Linear.Header(capacity: minimumCapacity)
        header.count = storage.initialization.count
        self.init(header: header, storage: storage)
    }
}
