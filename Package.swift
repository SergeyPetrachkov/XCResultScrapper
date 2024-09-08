// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

// MARK: - Externals

let swiftXML = Target.Dependency.product(name: "SwiftyXML", package: "SwiftyXML")
let argumentParser = Target.Dependency.product(name: "ArgumentParser", package: "swift-argument-parser")

// MARK: - Internals

// MARK: Utils
let utils = "XCResultScrapperUtils"
let utilsTarget: Target = .target(name: utils, path: path(for: utils))
let utilsTargetDependency: Target.Dependency = .target(name: utils)

// MARK: Domain
let xcResultScrapperDomain = "XCResultScrapperDomain"
let domainTarget: Target = .target(
    name: xcResultScrapperDomain,
    dependencies: [utilsTargetDependency],
    path: path(for: xcResultScrapperDomain)
)
let domainTargetDependency: Target.Dependency = .target(name: xcResultScrapperDomain)

// MARK: Report
let xcresultScrapperReport = "XCResultScrapperReport"
let xcresultScrapperReportTarget: Target = .target(
    name: xcresultScrapperReport,
    dependencies: [swiftXML, domainTargetDependency],
    path: path(for: xcresultScrapperReport)
)
let xcresultScrapperReportDependency: Target.Dependency = .target(name: xcresultScrapperReport)

// MARK: Core
let xcResultScrapper = "XCResultScrapperCore"
let scrapperTarget: Target = .target(
    name: xcResultScrapper,
    dependencies: [domainTargetDependency, utilsTargetDependency, xcresultScrapperReportDependency],
    path: path(for: xcResultScrapper)
)
let scrapperTargetDependency: Target.Dependency = .target(name: xcResultScrapper)

// MARK: Client
let xcResultScrapperClient = "XCResultScrapperClient"
let scrapperClientTarget: Target = .executableTarget(
    name: xcResultScrapperClient,
    dependencies: [scrapperTargetDependency, argumentParser],
    path: path(for: xcResultScrapperClient)
)

// MARK: - Manifest

let package = Package(
    name: "XCResultScrapper",
    products: [
        .library(
            name: "XCResultScrapper",
            targets: [xcResultScrapper]
        ),
        .executable(
            name: xcResultScrapperClient,
            targets: [xcResultScrapperClient]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/SergeyPetrachkov/SwiftyXML", branch: "master"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.2.2")
    ],
    targets: [
        utilsTarget,
        domainTarget,
        scrapperTarget,
        xcresultScrapperReportTarget,
        scrapperClientTarget,
        .testTarget(
            name: "XCResultScrapperTests",
            dependencies: ["XCResultScrapperCore"]
        )
    ]
)

// MARK: - Private helpers

func path(for target: String) -> String {
    "Sources/\(target)"
}
