// swift-tools-version:5.0
import PackageDescription

let package = Package(
    name: "WolfAnimation",
    platforms: [
        .iOS(.v12), .macOS(.v10_14), .tvOS(.v12)
    ],
    products: [
        .library(
            name: "WolfAnimation",
            targets: ["WolfAnimation"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", from: "5.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfLog", from: "2.0.0"),
        .package(url: "https://github.com/wolfmcnally/WolfNIO", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "WolfAnimation",
            dependencies: ["WolfCore", "WolfLog", "WolfNIO"])
        ]
)
