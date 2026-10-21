import Cardinal
import Index
import Ordinal
import Ownership
public import Property
import Span
import Storage
public import Store
import Tagged

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Remove {}
}

extension Buffer.Linear.Bounded.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear.Bounded>.Inout.Typed<
        S.Element
    >
}
