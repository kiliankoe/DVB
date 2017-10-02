// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "DVB",
    products: [
        .library(
            name: "DVB",
            targets: ["DVB"]),
    ],
    dependencies: [
        .package(url: "https://github.com/kiliankoe/gausskrueger", from: "0.4.0"),
    ],
    targets: [
        .target(
            name: "DVB",
            dependencies: ["GaussKrueger"]),
        .testTarget(
            name: "DVBTests",
            dependencies: ["DVB"]),
    ]
)
