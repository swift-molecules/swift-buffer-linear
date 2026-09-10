public import Store
import Span
import Index
import Tagged
import Ownership
import Ordinal
import Cardinal
import Ordinal
public import Property
import Storage_Memory

extension Buffer.Linear where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear>.Borrow.Typed<
        S.Element
    >
}
