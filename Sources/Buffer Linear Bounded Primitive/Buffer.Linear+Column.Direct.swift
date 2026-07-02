// ===----------------------------------------------------------------------===//
//
// This source file is part of the swift-primitives open source project
//
// Copyright (c) 2024-2026 Coen ten Thije Boonkkamp and the swift-primitives project authors
// Licensed under Apache License v2.0
//
// See LICENSE for license information
//
// ===----------------------------------------------------------------------===//

public import Store_Protocol_Primitives

// MARK: - Column.Direct (the axis-changing-alias fence, [DS-028])

/// `Buffer.Linear` is a DIRECT canonical column: it conforms to `Column.Direct` (the hoisted
/// `__ColumnDirect` marker, [DS-028] law 1), so axis-CHANGING front-door aliases
/// (`Array<E>.Small<n>`) may re-express over it while a cross-axis chain over `Shared`/bounded
/// fails to compile. Its capacity-twin column ``Column/Direct/Bounded`` is the fixed-capacity
/// `Buffer.Linear.Bounded`, through which the column-PRESERVING `.Bounded` alias maps
/// (`__X<S.Bounded>`, [DS-028] law 2). The nested `Buffer.Linear.Bounded` type witnesses the
/// `Bounded` requirement by member-name inference — no explicit typealias needed.
///
/// Placed in the `Buffer Linear Bounded Primitive` module because the twin references
/// `Buffer.Linear.Bounded`; the same `where S: Store.`Protocol`` bound the `Store.`Protocol``
/// conformance carries (`__ColumnDirect` refines it).
extension Buffer.Linear: __ColumnDirect where S: Store.`Protocol`, S: ~Copyable {}
