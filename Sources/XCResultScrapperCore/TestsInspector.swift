import Foundation
import XCResultScrapperDomain

public struct TestsInspector {

    public enum Constants {
        public static let diagnosticsReportKey = "kXCTAttachmentLegacyDiagnosticReportData"
        public static let missingJsonRegex = "Fatal error: (.+.json)"
        public static let swiftFiles = "Fatal error: (.+.swift)"
    }

    public init() { }

    /// Get failed tests grouped by probable reasons for a given tests run summary
    /// - Parameters:
    ///   - bundle: See `TestTargetsBundle` and the attached sample code
    /// - Returns: `TestsInspector.Result`
    ///
    /// - Usage:
    ///
    ///         let parser = XCResultParser()
    ///         let testsInspector = TestsInspector()
    ///         let newResults = try parser.extractResults(from: xcResultPath)
    ///         let failuresReport = testsInspector.examine(bundle: newResults)
    ///         if failuresReport.noFailures {
    ///             print("✅ No red tests!")
    ///         } else {
    ///             let crashReasons = testsInspector.extractCrashReasons(from: failuresReport.crashedTests, xcresultPath: xcResultPath)
    ///             print(
    ///             """
    ///             ❌ Crash reasons:
    ///              \(crashReasons.joined(separator: "\n"))
    ///             ❌ Assertion Failures:
    ///             \(failuresReport.assertionFailures.compactMap { $0.assertionReason }.joined(separator: "\n") )
    ///             ❌ All red tests:
    ///             \(failuresReport.allFailures.compactMap { $0.name.value }.joined(separator: "\n"))
    ///             """
    ///         )
    ///      }
    public func examine(bundle: TestTargetsBundle) -> TestsRunReport {
        let flattenedAllTestCases = bundle.flatMap { $0 }.compactMap { $0 }.flatMap { $0.allTests() }
        let flattenedFailedTestCases = bundle.flatMap { $0 }.compactMap { $0 }.flatMap { $0.allFailedTests() }
        // Lost connection. Might be rerun to ensure it's not a simulator fault.
        let lostConnections = flattenedFailedTestCases.filter(\.lostConnectionToApp) + flattenedFailedTestCases.filter(\.simulatorHang)
        // Lost connection may also be an assertion failure. It's not recoverable.
        let assertions = flattenedFailedTestCases.filter(\.isAssertionFailure)
        // Those who have `crash` word in summary.
        let crashed = flattenedFailedTestCases.filter(\.isCrash)

        return TestsRunReport(
            rawData: bundle,
            allTests: flattenedAllTestCases,
            allFailures: flattenedFailedTestCases,
            crashedTests: crashed,
            lostConnectionTests: lostConnections,
            assertionFailures: assertions
        )
    }
}
