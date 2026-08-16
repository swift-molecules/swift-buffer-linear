// MARK: - Buffer.Protocol Specialization Verification (A′ — logical surface)
// Purpose: Verify that a generic function over `some Buffer.Protocol` specializes
//          (no witness-table dispatch on the protocol surface) in RELEASE across a
//          MODULE boundary — the conditions that matter for the dedup arc ([EXP-017]).
//          A′ shape: Buffer.Protocol = count + isEmpty (no forEach; iteration is a
//          separate, orthogonal conformance). This probe exercises count + isEmpty
//          ONLY — terminal-suite SIL belongs to the coordinated iteration step.
// Hypothesis: With a statically-known concrete conformer (Buffer.Linear<Int>, heap),
//          the optimizer specializes the generic `count`/`isEmpty` calls; the
//          cross-module consumer makes a plain call into specialized code.
//          Buffer.Linear being ~Copyable with a suppressed associated Element does
//          not defeat this.
//
// Toolchain: Apple Swift 6.3.2 (swiftlang-6.3.2.1.108 clang-2100.1.1.101)
// Platform: arm64-apple-macosx26.0
//
// Result: PASS — the specialized bufferProtocolProbe<Buffer.Linear<Int>> that `main`
//         calls has signature (Builtin.Int64) -> Int and 0 witness_method: the entire
//         count + isEmpty surface flattens to a raw cmp_eq_Int64. The 4 witness_method
//         in the dump are all in the UNUSED [noinline] generic template, never called by
//         `main` (same residue as the prior Lever-2 run). Runtime: `probe: 10000`.
//         See Outputs/sil-release.txt.
// Date: 2026-05-26
//
// This is a cross-module consumer: it imports Buffer_Linear_Primitive (a different
// module) and calls `bufferProtocolProbe<B: Buffer.Protocol>(_:)`. The SIL of this
// module is dumped in release to count `witness_method` on the `some Buffer.Protocol`
// generic call (count + isEmpty surface only).

import Buffer_Linear_Primitive
import Buffer_Protocol_Primitives
import Index_Primitives
import Memory_Allocator_Primitive
import Storage_Contiguous_Primitives

/// The generic-over-`some Buffer.Protocol` call site under test.
///
/// Uses only the A′ protocol surface: `count` (Equatable compare to `.zero`) and
/// `isEmpty` (default impl). Constrained to `Element == Int`. M7: `count` is the
/// concrete `Index<Element>.Count`, so `.zero`/`==` are directly available and no
/// `Count == Index<Int>.Count` pin is needed (the pin is gone with the associated
/// type).
@inline(never)
func bufferProtocolProbe<B: Buffer.`Protocol` & ~Copyable>(_ b: borrowing B) -> Int
where B.Element == Int {
    if b.count == .zero { return 0 }  // `count` getter through the protocol surface
    if b.isEmpty { return 0 }  // `isEmpty` default impl (also count == .zero)
    return 1
}

var buffer = Buffer<Storage<Memory.Allocator<Memory.Heap>>.Contiguous<Int>>.Linear(
    minimumCapacity: Index<Int>.Count(1024)
)
var i = 0
while i < 1024 {
    buffer.append(1)
    i &+= 1
}

var acc = 0
for _ in 0..<10_000 {
    acc &+= bufferProtocolProbe(buffer)
}

// Each call returns 1 (buffer is non-empty); × 10_000 iterations.
print("probe:", acc)  // expect: 10000
