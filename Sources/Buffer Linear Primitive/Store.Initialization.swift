import Affine_Primitives_Standard_Library_Integration
import Ordinal_Primitives_Standard_Library_Integration
public import Storage_Contiguous_Primitives
import Storage_Protocol_Primitives
public import Store_Initialization_Primitives
public import Store_Protocol_Primitives

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
