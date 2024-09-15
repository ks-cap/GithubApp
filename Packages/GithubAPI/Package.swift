// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var core: Self { .product(name: "Core", package: "Core") }
    static var dependencies: Self { .product(name: "Dependencies", package: "swift-dependencies") }
}

let package = Package(
    name: "GithubAPI",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "GithubAPI", targets: ["GithubAPI"])
    ],
    dependencies: [
        // Internal dependencies
        .package(path: "../Core"),
        // External dependencies
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "GithubAPI",
            dependencies: [
                .core,
                .dependencies
            ]
        )
    ]
)
