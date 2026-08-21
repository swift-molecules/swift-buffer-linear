import Buffer_Linear_Primitive
import Buffer_Protocol_Primitives
import Index_Primitives
import Memory_Allocator_Primitive
import Storage_Contiguous_Primitives

@inline(never)
func bufferProtocolProbe<B: Buffer.`Protocol` & ~Copyable>(_ b: borrowing B) -> Int
where B.Element == Int {
    if b.count == .zero { return 0 }
    if b.isEmpty { return 0 }
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

print("probe:", acc)
