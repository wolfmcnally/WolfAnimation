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
            targets: ["WolfAnimation"]),
        ],
    dependencies: [
        .package(url: "https://github.com/wolfmcnally/WolfCore", .branch("Swift-5.1")),
        .package(url: "https://github.com/wolfmcnally/WolfLog", .branch("Swift-5.1")),
        .package(url: "https://github.com/wolfmcnally/WolfNIO", .branch("Swift-5.1")),
    ],
    targets: [
        .target(
            name: "WolfAnimation",
            dependencies: ["WolfCore", "WolfLog", "WolfNIO"])
        ]
)
