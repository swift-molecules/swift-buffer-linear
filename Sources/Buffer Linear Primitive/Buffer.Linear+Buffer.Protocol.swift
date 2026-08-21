public import Buffer_Protocol_Primitives

extension Buffer.Linear: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
