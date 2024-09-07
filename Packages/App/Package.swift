// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target {
    static func feature(name: String, dependencies: [Dependency] = []) -> Target {
        .target(name: name, dependencies: dependencies, path: "Sources/Features/\(name)")
    }
}

extension Target.Dependency {
    static var common: Self { .target(name: "Common") }
    static var composableArchitecture: Self {
        .product(name: "ComposableArchitecture", package: "swift-composable-architecture")
    }
    static var core: Self { .product(name: "Core", package: "Core") }
}

var targets: [Target] = [
    .target(name: "Common"),
    .feature(
        name: "Users",
        dependencies: [.common, .composableArchitecture, .core]
    ),
    .testTarget(name: "UsersTests", dependencies: ["Users"])
]

let targetsExcludingTests = targets.filter { !$0.isTest }

targets.append(
    .target(
        name: "Root",
        dependencies: [
            .composableArchitecture,
            .core
        ] + targetsExcludingTests.map { .target(name: $0.name) }
    )
)

let package = Package(
    name: "App",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Root", targets: ["Root"])
    ] + targetsExcludingTests.map(\.name).map { .library(name: $0, targets: [$0]) },
    dependencies: [
        // Internal dependencies
        .package(name: "Core", path: "../Core"),
        // External dependencies
        .package(url: "https://github.com/pointfreeco/swift-composable-architecture", from: "1.14.0")
    ],
    targets: targets
)
