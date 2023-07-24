public struct TestTargetSummary {
    public let type: ValueSupertype
    public let diagnosticsDirectoryName, name, targetName: XCMetaField
    public let projectRelativePath: XCMetaField?
    public let testKind: XCMetaField
    public var suites: [TestsSuiteSummary]

    public init(from xcTargetSummary: TestableTargetSummary) {
        self.type = xcTargetSummary._type
        self.diagnosticsDirectoryName = xcTargetSummary.diagnosticsDirectoryName
        self.name = xcTargetSummary.name
        self.targetName = xcTargetSummary.targetName
        self.projectRelativePath = xcTargetSummary.projectRelativePath
        self.testKind = xcTargetSummary.testKind

        let suiteBundles = xcTargetSummary
            .tests
            .values
            .compactMap { $0.subtests?.values.compactMap { $0.subtests } }
            .flatMap { $0 }

        self.suites = suiteBundles.compactMap { TestsSuiteSummary(from: $0) }
    }

    public func allFailedTests() -> [TestCase] {
        suites.flatMap { suite in
            suite
                .testClasses
                .flatten()
                .filter { $0.testStatus.value == TestResult.failure.rawValue }
        }
    }

    public func allTests() -> [TestCase] {
        suites.flatMap { $0.testClasses.flatten() }
    }
}
