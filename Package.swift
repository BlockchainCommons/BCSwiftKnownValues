// swift-tools-version: 5.10

import PackageDescription

let package = Package(
    name: "KnownValues",
    platforms: [
        .macOS(.v13),
        .iOS(.v14),
        .macCatalyst(.v14)
    ],
    products: [
        .library(
            name: "KnownValues",
            targets: ["KnownValues"]),
    ],
    dependencies: [
        .package(url: "https://github.com/BlockchainCommons/URKit", from: "14.0.0"),
        .package(url: "https://github.com/BlockchainCommons/BCSwiftTags", from: "0.1.0")
    ],
    targets: [
        .target(
            name: "KnownValues",
            dependencies: [
                "URKit",
                .product(name: "BCTags", package: "BCSwiftTags"),
            ]
        ),
        .testTarget(
            name: "KnownValuesTests",
            dependencies: ["KnownValues"]),
    ]
)
