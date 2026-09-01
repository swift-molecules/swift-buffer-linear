public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership_Inout
public import Ownership_Borrow
public import Ordinal_Tagged
public import Ordinal_Protocol
public import Ordinal_Cardinal
public import Cardinal_Tagged
public import Cardinal_Carrier
public import Ordinal
public import Index
import Affine_Standard_Library_Integration
public import Cardinal
import Ordinal_Standard_Library_Integration
public import Tagged
public import Storage

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
