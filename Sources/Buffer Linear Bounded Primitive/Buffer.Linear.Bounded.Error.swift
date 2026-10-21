import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Store
import Tagged

extension Buffer.Linear.Bounded where S: ~Copyable {

    public enum Error: Swift::Error, Sendable, Equatable {

        case capacityExceeded
    }
}
