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
            url: "https://github.com/swift-atoms/swift-buffer.git",
            branch: "main"
        ),

        .package(
            url: "https://github.com/swift-atoms/swift-storage.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-allocation.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-memory-small.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-storage-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-index.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-affine.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ordinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-memory.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-span.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-finite.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-sequence.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-iterator.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-cardinal.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-tagged.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-property.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-atoms/swift-ownership.git",
            branch: "main"
        ),
        .package(
            url: "https://github.com/swift-molecules/swift-property-ownership.git",
            branch: "main"
        ),
    ],
    targets: [

        .target(
            name: "Buffer Linear Primitive",
            dependencies: [
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Finite", package: "swift-finite"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),
        .target(
            name: "Buffer Linear Bounded Primitive",
            dependencies: [
                "Buffer Linear Primitive",
                .product(name: "Buffer", package: "swift-buffer"),
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(
                    name: "Memory Allocator Protocol",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Finite", package: "swift-finite"),
                .product(name: "Index", package: "swift-index"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
                .product(name: "Property", package: "swift-property"),
                .product(name: "Ownership", package: "swift-ownership"),
                .product(name: "Property Ownership", package: "swift-property-ownership"),
            ]
        ),

        .target(
            name: "Buffer Linear",
            dependencies: [
                "Buffer Linear Primitive",
                "Buffer Linear Bounded",
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .target(
            name: "Buffer Linear Bounded",
            dependencies: [
                "Buffer Linear Bounded Primitive",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Span", package: "swift-span"),
                .product(name: "Sequence", package: "swift-sequence"),
                .product(name: "Iterator", package: "swift-iterator"),
                .product(
                    name: "Affine Standard Library Integration",
                    package: "swift-affine"
                ),
                .product(
                    name: "Ordinal Standard Library Integration",
                    package: "swift-ordinal"
                ),
                .product(name: "Ordinal", package: "swift-ordinal"),
                .product(name: "Ordinal Comparison", package: "swift-ordinal"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),

        .target(
            name: "Buffer Linear Test Support",
            dependencies: [
                "Buffer Linear",
                "Buffer Linear Bounded",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(
                    name: "Memory Allocator",
                    package: "swift-memory-allocation"
                ),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ],
            path: "Tests/Support"
        ),

        .testTarget(
            name: "Buffer Linear Tests",
            dependencies: [
                "Buffer Linear",
                "Buffer Linear Test Support",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
            ]
        ),
        .testTarget(
            name: "Buffer Linear Bounded Tests",
            dependencies: [
                "Buffer Linear Bounded",
                "Buffer Linear Test Support",
                .product(name: "Storage", package: "swift-storage"),
                .product(name: "Storage Memory", package: "swift-storage-memory"),
                .product(name: "Memory", package: "swift-memory"),
                .product(name: "Memory Small", package: "swift-memory-small"),
                .product(name: "Index", package: "swift-index"),
                .product(name: "Cardinal", package: "swift-cardinal"),
                .product(name: "Tagged", package: "swift-tagged"),
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
