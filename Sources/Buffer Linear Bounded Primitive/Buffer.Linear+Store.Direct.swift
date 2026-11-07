import Cardinal
import Index
import Ordinal
import Ownership
import Span
import Storage
public import Store
import Tagged

extension Buffer.Linear: Store.Direct where S: Store.`Protocol`, S: ~Copyable {}
