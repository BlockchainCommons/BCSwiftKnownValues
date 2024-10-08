// swift-tools-version: 6.0

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
        .package(url: "https://github.com/BlockchainCommons/BCSwiftDCBOR", from: "2.0.0"),
    ],
    targets: [
        .target(
            name: "KnownValues",
            dependencies: [
                .product(name: "DCBOR", package: "BCSwiftDCBOR"),
            ]
        ),
        .testTarget(
            name: "KnownValuesTests",
            dependencies: ["KnownValues"]),
    ]
)
