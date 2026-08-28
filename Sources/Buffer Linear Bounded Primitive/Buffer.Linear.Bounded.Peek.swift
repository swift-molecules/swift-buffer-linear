import Ordinal
import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Property_Ownership
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
