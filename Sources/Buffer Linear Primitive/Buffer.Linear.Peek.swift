import Cardinal
import Index
import Ordinal
import Ownership
public import Property
import Span
import Storage
public import Store
import Tagged

extension Buffer.Linear where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear>.Borrow.Typed<
        S.Element
    >
}
