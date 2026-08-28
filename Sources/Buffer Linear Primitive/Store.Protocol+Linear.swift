public import Ordinal
import Affine_Standard_Library_Integration
public import Cardinal
public import Index
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage

extension __StoreProtocol where Self: ~Copyable {

    @inlinable
    package static func linearAppend(
        _ element: consuming Element,
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) {
        let slot = count.map { Ordinal($0.rawValue) }
        storage.initialize(at: slot, to: consume element)
        count = count.adding(saturating: .one)
    }

    @inlinable
    package static func linearRemoveFirst(
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) -> Element {
        let element = storage.move(at: .zero)
        if count > .one {
            let secondSlot = Tagged<Element, Cardinal>.one.map { Ordinal($0.rawValue) }
            let followingCount = count.subtracting(saturating: .one)
            storage.moveInitialize(from: secondSlot, to: .zero, count: followingCount)
        }
        count = count.subtracting(saturating: .one)
        return element
    }

    @inlinable
    package static func linearRemove(
        at index: Index<Element>,
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) -> Element {
        precondition(index < Index<Element>(count), "Index out of bounds")
        let element = storage.move(at: index)
        let nextSlot = index.advanced(by: .one)
        let followingCount = count.subtracting(
            saturating: Tagged<Element, Cardinal>(nextSlot)
        )
        if followingCount > .zero {
            storage.moveInitialize(from: nextSlot, to: index, count: followingCount)
        }
        count = count.subtracting(saturating: .one)
        return element
    }

    @inlinable
    package static func linearReplace(
        at index: Index<Element>,
        with newElement: consuming Element,
        storage: inout Self
    ) -> Element {
        let old = storage.move(at: index)
        storage.initialize(at: index, to: consume newElement)
        return old
    }

    @inlinable
    package static func linearConsumeBack(
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) -> Element {
        let newCount = count.subtracting(saturating: .one)
        let element = storage.move(at: newCount.map { Ordinal($0.rawValue) })
        count = newCount
        return element
    }

    @inlinable
    package static func linearSwap(
        at i: Index<Element>,
        with j: Index<Element>,
        storage: inout Self
    ) {
        storage.swapAt(i, j)
    }

    @inlinable
    package static func linearDeinitializeAll(
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) {
        if count > .zero {
            storage.deinitialize(range: Store.Span(start: .zero, count: count))
        }
        count = .zero
    }

    @inlinable
    package static func linearTruncate(
        to newCount: Tagged<Element, Cardinal>,
        count: inout Tagged<Element, Cardinal>,
        storage: inout Self
    ) {
        guard newCount < count else { return }
        let start: Index<Element> = newCount.map { Ordinal($0.rawValue) }
        storage.deinitialize(
            range: Store.Span(
                start: start,
                count: count.subtracting(saturating: newCount)
            )
        )
        count = newCount
    }
}
