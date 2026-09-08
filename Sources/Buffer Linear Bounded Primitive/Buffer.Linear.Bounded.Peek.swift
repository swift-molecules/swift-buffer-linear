public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal
import Ordinal
public import Property
import Storage_Memory

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Bounded.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear.Bounded>.Borrow.Typed<
        S.Element
    >
}
