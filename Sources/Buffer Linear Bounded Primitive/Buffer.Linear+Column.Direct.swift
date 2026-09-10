import Index
import Tagged
public import Store
import Span
import Ownership
import Ordinal
import Cardinal
import Storage

extension Buffer.Linear: Store.Direct where S: Store.`Protocol`, S: ~Copyable {}
