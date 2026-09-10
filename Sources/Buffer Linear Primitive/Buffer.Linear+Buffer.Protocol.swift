public import Buffer
import Cardinal
import Index
import Ordinal
import Tagged

extension Buffer.Linear: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
