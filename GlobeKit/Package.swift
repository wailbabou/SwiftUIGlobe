// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "GlobeKit",
    platforms: [
        .iOS(.v17),
        .macOS(.v14)
    ],
    products: [
        .library(
            name: "GlobeKit",
            targets: ["GlobeKit"]
        ),
    ],
    targets: [
        .target(
            name: "GlobeKit",
            dependencies: []
        )
    ]
)
