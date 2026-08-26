import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Remove {}
}

extension Buffer.Linear.Bounded.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear.Bounded>.Inout.Typed<
        S.Element
    >
}
