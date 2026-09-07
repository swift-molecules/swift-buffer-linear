public import Index
public import Tagged
public import Store_Ledgered
public import Store_Operations
public import Span_Protocol
public import Store_Initialization
public import Store_Protocol
public import Store
public import Ownership
public import Ordinal
public import Cardinal
import Ordinal_Standard_Library_Integration
public import Property_Ownership
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
