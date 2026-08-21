import Affine_Primitives_Standard_Library_Integration
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Bounded.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear.Bounded>.Borrow.Typed<
        S.Element
    >
}
