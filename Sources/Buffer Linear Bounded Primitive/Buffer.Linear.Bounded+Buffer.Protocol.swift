public import Buffer
import Cardinal
import Index
import Ordinal
import Tagged

extension Buffer.Linear.Bounded: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
