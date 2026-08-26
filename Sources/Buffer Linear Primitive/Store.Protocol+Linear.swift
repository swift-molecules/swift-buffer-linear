import Affine_Standard_Library_Integration
public import Index
import Ordinal_Standard_Library_Integration
public import Storage_Protocol
public import Store_Protocol

extension __StoreProtocol where Self: ~Copyable {

    @inlinable
    package static func linearAppend(
        _ element: consuming Element,
        count: inout Index<Element>.Count,
        storage: inout Self
    ) {
        let slot = count.map(Ordinal.init)
        storage.initialize(at: slot, to: consume element)
        count = count.add.saturating(.one)
    }

    @inlinable
    package static func linearRemoveFirst(
        count: inout Index<Element>.Count,
        storage: inout Self
    ) -> Element {
        let element = storage.move(at: .zero)
        if count > .one {
            let secondSlot = Index<Element>.Count.one.map(Ordinal.init)
            let followingCount = count.subtract.saturating(.one)
            storage.moveInitialize(from: secondSlot, to: .zero, count: followingCount)
        }
        count = count.subtract.saturating(.one)
        return element
    }

    @inlinable
    package static func linearRemove(
        at index: Index<Element>,
        count: inout Index<Element>.Count,
        storage: inout Self
    ) -> Element {
        precondition(index < count, "Index out of bounds")
        let element = storage.move(at: index)
        let nextSlot = index + .one
        let followingCount = count.subtract.saturating(nextSlot.map(Cardinal.init))
        if followingCount > .zero {
            storage.moveInitialize(from: nextSlot, to: index, count: followingCount)
        }
        count = count.subtract.saturating(.one)
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
        count: inout Index<Element>.Count,
        storage: inout Self
    ) -> Element {
        let newCount = count.subtract.saturating(.one)
        let element = storage.move(at: newCount.map(Ordinal.init))
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
        count: inout Index<Element>.Count,
        storage: inout Self
    ) {
        if count > .zero {
            let upper: Index<Element> = count.map(Ordinal.init)
            storage.deinitialize(range: .zero..<upper)
        }
        count = .zero
    }

    @inlinable
    package static func linearTruncate(
        to newCount: Index<Element>.Count,
        count: inout Index<Element>.Count,
        storage: inout Self
    ) {
        guard newCount < count else { return }
        let start: Index<Element> = newCount.map(Ordinal.init)
        let upper: Index<Element> = count.map(Ordinal.init)
        storage.deinitialize(range: start..<upper)
        count = newCount
    }
}
