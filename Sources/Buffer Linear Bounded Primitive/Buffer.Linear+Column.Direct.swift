public import Storage

extension Buffer.Linear: Store.Direct where S: Store.`Protocol`, S: ~Copyable {}
