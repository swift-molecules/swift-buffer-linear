import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Buffer.Linear where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear>.Borrow.Typed<
        S.Element
    >
}
