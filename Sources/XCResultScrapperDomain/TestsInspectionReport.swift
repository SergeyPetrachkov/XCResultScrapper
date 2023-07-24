public typealias TestTargetsBundle = [[TestTargetSummary]]

public struct TestsRunReport {
    public let rawData: TestTargetsBundle

    public let allTests: [TestCase]
    public let allFailures: [TestCase]
    public let crashedTests: [TestCase]
    public let lostConnectionTests: [TestCase]
    public let assertionFailures: [TestCase]

    public var noRecoverableTests: Bool {
        recoverableTests.isEmpty
    }

    public var noFailures: Bool {
        allFailures.isEmpty
    }
    /// These tests might be rerun to ensure failure is not a simulator fault
    public var recoverableTests: [TestCase] {
        lostConnectionTests.filter { !$0.isAssertionFailure }
    }

    public init(
        rawData: TestTargetsBundle,
        allTests: [TestCase],
        allFailures: [TestCase],
        crashedTests: [TestCase],
        lostConnectionTests: [TestCase],
        assertionFailures: [TestCase]
    ) {
        self.rawData = rawData
        self.allTests = allTests
        self.allFailures = allFailures
        self.crashedTests = crashedTests
        self.lostConnectionTests = lostConnectionTests
        self.assertionFailures = assertionFailures
    }
}
