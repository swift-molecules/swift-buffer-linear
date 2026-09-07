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
extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
