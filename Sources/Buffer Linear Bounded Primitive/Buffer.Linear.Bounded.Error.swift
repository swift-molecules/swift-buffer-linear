import Index
import Tagged
import Store
import Span
import Ownership
import Ordinal
import Cardinal
extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Error: Swift.Error, Sendable, Equatable {

        case capacityExceeded
    }
}
