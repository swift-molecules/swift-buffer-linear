public import Buffer_Protocol

extension Buffer.Linear: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
