public import Store_Protocol_Primitives

extension Buffer.Linear: Store.Direct where S: Store.`Protocol`, S: ~Copyable {}
