// swift-tools-version: 6.4

import PackageDescription

let package = Package(
    name: "swift-buffer-linear",
    platforms: [
        .macOS(.v27),
        .iOS(.v27),
        .tvOS(.v27),
        .watchOS(.v27),
        .visionOS(.v27),
    ],
    products: [

        .library(name: "Buffer Linear Primitive", targets: ["Buffer Linear Primitive"]),
        .library(
            name: "Buffer Linear Bounded Primitive",
            targets: ["Buffer Linear Bounded Primitive"]
        ),

        .library(name: "Buffer Linear", targets: ["Buffer Linear"]),
        .library(
            name: "Buffer Linear Bounded",
            targets: ["Buffer Linear Bounded"]
        ),
        .library(
            name: "Buffer Linear Test Support",
            targets: ["Buffer Linear Test Support"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/swift-molecules/swift-buffer.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-molecules/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-heap.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-finite.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-sequence.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-molecules/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-iterator.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Buffer Linear Primitive",
            dependencies: [
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Finite", package: "swift-finite"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Buffer Linear Bounded Primitive",
            dependencies: [
                "Buffer Linear Primitive",
                .product(name: "Buffer Primitive", package: "swift-buffer"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(name: "Store Protocol", package: "swift-storage"),
                .product(
                    name: "Store Initialization",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Finite", package: "swift-finite"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .target(
            name: "Buffer Linear",
            dependencies: [
                "Buffer Linear Primitive",
                "Buffer Linear Bounded",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(
                    name: "Memory Iterator",
                    package: "swift-memory-iterator"
                ),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),
        .target(
            name: "Buffer Linear Bounded",
            dependencies: [
                "Buffer Linear Bounded Primitive",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span Protocol", package: "swift-span"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterable", package: "swift-iterator"),
                .product(
                    name: "Memory Iterator",
                    package: "swift-memory-iterator"
                ),
                .product(name: "Affine", package: "swift-affine"),
                .product(name: "Ordinal", package: "swift-ordinal"),
            ]
        ),

        .executableTarget(
            name: "Buffer Protocol SIL Probe",
            dependencies: [
                "Buffer Linear Primitive",
                .product(name: "Buffer Protocol", package: "swift-buffer"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
            ]
        ),

        .target(
            name: "Buffer Linear Test Support",
            dependencies: [
                "Buffer Linear",
                "Buffer Linear Bounded",
                .product(
                    name: "Storage Contiguous",
                    package: "swift-storage"
                ),
                .product(name: "Storage Protocol", package: "swift-storage"),
                .product(
                    name: "Memory Allocator Primitive",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory Heap", package: "swift-memory-heap"),
                .product(
                    name: "Memory Test Support",
                    package: "swift-memory"
                ),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Linear Tests",
            dependencies: [
                "Buffer Linear",
                "Buffer Linear Test Support",
                .product(name: "Store Protocol", package: "swift-storage"),
            ]
        ),
        .testTarget(
            name: "Buffer Linear Bounded Tests",
            dependencies: [
                "Buffer Linear Bounded",
                "Buffer Linear Test Support",
                .product(name: "Store Protocol", package: "swift-storage"),
            ]
        ),
    ],
    swiftLanguageModes: [.v6]
)

for target in package.targets where ![.system, .binary, .plugin, .macro].contains(target.type) {
    let ecosystem: [SwiftSetting] = [
        .strictMemorySafety(),
        .enableUpcomingFeature("ExistentialAny"),
        .enableUpcomingFeature("InternalImportsByDefault"),
        .enableUpcomingFeature("MemberImportVisibility"),
        .enableUpcomingFeature("NonisolatedNonsendingByDefault"),
        .enableExperimentalFeature("Lifetimes"),
        .enableUpcomingFeature("InferIsolatedConformances"),
    ]

    let package: [SwiftSetting] = [
        .enableExperimentalFeature("BuiltinModule"),
        .enableExperimentalFeature("RawLayout"),
    ]

    target.swiftSettings = (target.swiftSettings ?? []) + ecosystem + package
}
