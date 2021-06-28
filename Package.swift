// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "PayerModule",
    products: [
        // Products define the executables and libraries a package produces, and make them visible to other packages.
        .library(
            name: "PayerModule",
            targets: ["PayerModule"]),
    ],
    dependencies: [
        .package(url: "https://github.com/bizz84/SwiftyStoreKit.git", from: "0.16.3"),
        .package(url: "https://github.com/sunshinejr/SwiftyUserDefaults.git", .upToNextMajor(from: "5.3.0")),
    ],
    targets: [
        // Targets are the basic building blocks of a package. A target can define a module or a test suite.
        // Targets can depend on other targets in this package, and on products in packages this package depends on.
        .target(
            name: "PayerModule",
            dependencies: ["SwiftyUserDefaults",
                           "SwiftyStoreKit",
            ]),
    ])
