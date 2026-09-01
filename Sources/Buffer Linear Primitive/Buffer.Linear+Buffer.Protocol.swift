public import Buffer
public import Buffer_Protocol
public import Cardinal
public import Index
public import Ordinal_Protocol
public import Tagged

extension Buffer.Linear: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
