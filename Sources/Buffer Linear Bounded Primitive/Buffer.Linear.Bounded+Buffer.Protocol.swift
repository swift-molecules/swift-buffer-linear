public import Buffer_Protocol_Primitives

extension Buffer.Linear.Bounded: Buffer.`Protocol` where S: ~Copyable {

    public typealias Element = S.Element
}
