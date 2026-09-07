public import Index
public import Tagged
public import Store
public import Span
public import Ownership
public import Ordinal
public import Cardinal
public import Storage

extension Buffer.Linear: Store.Direct where S: Store.`Protocol`, S: ~Copyable {}
