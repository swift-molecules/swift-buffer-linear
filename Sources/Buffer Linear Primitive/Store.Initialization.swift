import Affine_Standard_Library_Integration
import Ordinal_Standard_Library_Integration
public import Storage_Contiguous
import Storage_Protocol
public import Store_Initialization
public import Store_Protocol

extension Store.Initialization where Element: ~Copyable & ~Escapable {

    @inlinable
    public init<S: Store.`Protocol` & ~Copyable>(
        _ header: Buffer<S>.Linear.Header
    ) where S.Element == Element {
        if header.count == .zero {
            self = .empty
            return
        }
        self = .one(.zero..<header.count.map(Ordinal.init))
    }
}
