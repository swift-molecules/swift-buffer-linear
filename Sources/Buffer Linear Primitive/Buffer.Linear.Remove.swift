public import Store
public import Span
public import Index
public import Tagged
public import Ownership
public import Ordinal
public import Cardinal
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
