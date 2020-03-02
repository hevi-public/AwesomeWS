// swift-tools-version:5.2

import PackageDescription

let package = Package(
    name: "WS",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "WS", targets: ["WS"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.0.0-rc"),
        .package(url: "https://github.com/vapor/websocket-kit.git", from: "2.0.0-rc")
    ],
    targets: [
        .target(name: "WS", dependencies: [
            .product(name: "Vapor", package: "vapor"),
            .product(name: "WebSocketKit", package: "websocket-kit"),
        ]),
        .testTarget(name: "WSTests", dependencies: [
            .target(name: "WS"),
            .product(name: "WebSocketKit", package: "websocket-kit"),
        ]),
    ]
)
