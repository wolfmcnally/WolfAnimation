// swift-tools-version:5.1
import PackageDescription

let package = Package(
    name: "WolfAnimation",
    platforms: [
        .iOS(.v12), .tvOS(.v12), .macOS(.v10_13)
    ],
    products: [
        .library(
            name: "WolfAnimation",
            type: .dynamic,
            targets: ["WolfAnimation"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfConcurrency", from: "3.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLog", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNIO", from: "1.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfFoundation", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNumerics", from: "4.0.0"),
    ],
    targets: [
        .target(
            name: "WolfAnimation",
            dependencies: [
                "WolfConcurrency",
                "WolfLog",
                "WolfNIO",
                "WolfFoundation",
                "WolfNumerics"
        ])
        ]
)
