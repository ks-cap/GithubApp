// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

extension Target.Dependency {
    static var dependencies: Self {
        .product(name: "Dependencies", package: "swift-dependencies")
    }
    static var dependenciesMacros: Self {
        .product(name: "DependenciesMacros", package: "swift-dependencies")
    }
}

let package = Package(
    name: "Core",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Core", targets: ["Core"])
    ],
    dependencies: [
        // External dependencies
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.3.9")
    ],
    targets: [
        .target(
            name: "Core",
            dependencies: [
                .dependencies,
                .dependenciesMacros
            ]
        )
    ]
)
