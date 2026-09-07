public import Buffer
public import Cardinal
public import Index
public import Ordinal
public import Tagged

extension Buffer.Linear.Bounded: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
