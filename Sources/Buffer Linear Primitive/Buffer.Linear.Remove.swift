import Ordinal
import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Property_Ownership
public import Property
import Storage_Memory

extension Buffer.Linear where S: ~Copyable {

    public enum Remove {}
}

extension Buffer.Linear.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear>.Inout.Typed<
        S.Element
    >
}
