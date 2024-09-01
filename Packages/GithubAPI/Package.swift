// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "GithubAPI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "GithubAPI", targets: ["GithubAPI"]),
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.9"),
    ],
    targets: [
        .target(
            name: "GithubAPI",
            dependencies: [
                .product(name: "Dependencies", package: "swift-dependencies"),
                .product(name: "DependenciesMacros", package: "swift-dependencies")
            ]
        ),
        .testTarget(
            name: "GithubAPITests",
            dependencies: ["GithubAPI"]
        )
    ]
)
