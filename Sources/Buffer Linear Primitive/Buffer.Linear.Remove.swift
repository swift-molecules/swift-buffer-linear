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

    public enum Remove {}
}

extension Buffer.Linear.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear>.Inout.Typed<
        S.Element
    >
}
