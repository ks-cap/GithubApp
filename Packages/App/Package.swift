// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "App",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "App", targets: ["Features"]),
    ],
    dependencies: [
        .package(name: "GithubAPI", path: "../GithubAPI"),
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.14.0")
    ],
    targets: [
        .target(
            name: "Features",
            dependencies: [
                .product(name: "ComposableArchitecture", package: "swift-composable-architecture"),
                .product(name: "GithubAPI", package: "GithubAPI")
            ]
        ),
        .testTarget(
            name: "AppTests",
            dependencies: ["Features"]
        )
    ]
)
