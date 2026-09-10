import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal
import Cardinal
import Ordinal
public import Property
import Storage_Memory

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Remove {}
}

extension Buffer.Linear.Bounded.Remove where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Remove, Buffer<S>.Linear.Bounded>.Inout.Typed<
        S.Element
    >
}
