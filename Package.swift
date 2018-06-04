// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "TwentyOne",
    dependencies: [
        .package(url: "https://github.com/ReSwift/ReSwift.git", .revision("40179c2ed056b17fee37b4bf9fa87b95d935df48")),
        .package(url: "https://github.com/vapor/websocket.git", from: "1.0.0"),
    ],
    targets: [
        .target(name: "Run", dependencies: [
            "TwentyOneCore",
            "WebSocket",
        ]),
        .target(name: "TwentyOneCore", dependencies: [
            "ReSwift",
            "WebSocket",
        ]),
        .testTarget(name: "TwentyOneCoreTests", dependencies: [
            "TwentyOneCore",
        ])
    ]
)

