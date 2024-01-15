// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import CompilerPluginSupport
import PackageDescription

let package = Package(
  name: "MemberwiseInitializer",
  platforms: [.macOS(.v12), .iOS(.v14), .macCatalyst(.v14)],
  products: [
    // Products define the executables and libraries a package produces, making them visible to other packages.
    .library(
      name: "MemberwiseInitializer",
      targets: ["MemberwiseInitializer"]
    )
  ],
  dependencies: [
    //    .package(path: "../MacroTester"),
    .package(url: "https://github.com/apple/swift-syntax.git", from: "509.0.0")
//    .package(
//      url: "https://github.com/realm/SwiftLint",
//      from: "0.53.0"
//    )
  ],
  targets: [
    // Targets are the basic building blocks of a package, defining a module or a test suite.
    // Targets can depend on other targets in this package and products from dependencies.
    // Macro implementation that performs the source transformation of a macro.
    .macro(
      name: "MemberwiseInitializerMacros",
      dependencies: [
        .product(name: "SwiftSyntaxMacros", package: "swift-syntax"),
        .product(name: "SwiftCompilerPlugin", package: "swift-syntax")
      ]
    ),

    // Library that exposes a macro as part of its API, which is used in client programs.
    .target(
      name: "MemberwiseInitializer",
      dependencies: ["MemberwiseInitializerMacros"]
    )

//    https://developer.apple.com/documentation/xcode-release-notes/xcode-15-release-notes
//    Swift Packages
//    Known Issues
//    Swift Macros may fail to build when target destination is a platform other than macOS. (110541100)
//    Workaround: Build by choosing the macOS destination, or by removing the .testTarget from package.swift.

//    // A test target used to develop the macro implementation.
//    .testTarget(
//      name: "MemberwiseInitializerTests",
//      dependencies: [
//        "MemberwiseInitializerMacros",
//        .product(name: "SwiftSyntaxMacrosTestSupport", package: "swift-syntax")
//      ],
//      plugins: [.plugin(name: "SwiftLintPlugin", package: "SwiftLint")]
//    )
  ]
)
