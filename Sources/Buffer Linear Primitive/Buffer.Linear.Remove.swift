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

    public enum Remove {}
}

extension Buffer.Linear.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear>.Inout.Typed<
        S.Element
    >
}
