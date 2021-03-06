// swift-tools-version:5.3
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
  name: "VisionUtils",
  platforms: [
    .macOS(.v10_15), .iOS(.v13)
  ],
  products: [
    // Products define the executables and libraries a package produces, and make them visible to other packages.
    .library(
      name: "VisionUtils",
      targets: ["VisionUtils"]),

    .executable(name: "runVision",
                targets: ["VisionClient"])
  ],
  dependencies: [
    // Dependencies declare other packages that this package depends on.
    // .package(url: /* package url */, from: "1.0.0"),
    .package(url: "https://github.com/apple/swift-argument-parser", .upToNextMinor(from: "0.2.0")),
  ],
  targets: [
    // Targets are the basic building blocks of a package. A target can define a module or a test suite.
    // Targets can depend on other targets in this package, and on products in packages this package depends on.
    .target(
      name: "VisionUtils",
      dependencies: []),

    .testTarget(
      name: "VisionUtilsTests",
      dependencies: ["VisionUtils"],
      resources:[
        .process("soccerFans.jpg")
        ,        .process("potatoes.jpg")

      ]),

    .target(name: "VisionClient",
            dependencies: [
              "VisionUtils",
              .product(name: "ArgumentParser", package: "swift-argument-parser")],
            path: nil,
            exclude: [],
            sources: nil,
            resources: nil,
            publicHeadersPath: nil,
            cSettings: nil,
            cxxSettings: nil,
            swiftSettings: nil,
            linkerSettings: nil)
  ]
)
