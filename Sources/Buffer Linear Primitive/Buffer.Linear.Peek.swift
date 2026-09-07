public import Store_Operations
public import Store_Ledgered
public import Span_Protocol
public import Index
public import Tagged
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

extension Buffer.Linear where S: ~Copyable {

    public enum Peek {}
}

extension Buffer.Linear.Peek where S: ~Copyable {

    public typealias View = Property<Buffer<S>.Linear.Peek, Buffer<S>.Linear>.Borrow.Typed<
        S.Element
    >
}
