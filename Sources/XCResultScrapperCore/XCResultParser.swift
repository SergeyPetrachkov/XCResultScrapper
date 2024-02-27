import XCResultScrapperDomain

public struct XCResultParser {

    public enum Constants {
        public static let diagnosticsReportKey = "kXCTAttachmentLegacyDiagnosticReportData"
        public static let missingJsonRegex = "Fatal error: (.+.json)"
        public static let swiftFiles = "Fatal error: (.+.swift)"
    }

    public init() {}

    public func parse(xcresultPath: String) throws -> XCResult {
        try Shell.parseXCResult(xcresultPath: xcresultPath)
    }

    public func extractResults(from xcresultPath: String) throws -> TestTargetsBundle {
        var summaries = TestTargetsBundle()
        let xcresult = try parse(xcresultPath: xcresultPath)

        try xcresult.actions.values.forEach { actionValue in
            if let id = actionValue.actionResult.testsRef?.id.value {
                let testsSummary = try Shell.extractTestsSummary(
                    xcresultPath: xcresultPath,
                    id: id
                )
                let targets = testsSummary
                    .summaries
                    .values
                    .flatMap { $0.testableSummaries.values }

                var targetViews = targets.map { TestTargetSummary(from: $0) }

                try targetViews.mutateEach { target in
                    try target.suites.mutateEach { testSuite in
                        try testSuite.testClasses.mutateEach { testClass in
                            try testClass.subtests.values.mutateEach { testCase in
                                if testCase.testStatus.value == TestResult.failure.rawValue,
                                    let id = testCase.summaryRef?.id.value
                                {
                                    var failureReport = try Shell.extractFailedTestSummary(
                                        xcresultPath: xcresultPath,
                                        id: id
                                    )
                                    if failureReport.isCrash {
                                        let crashReason = extractCrashReasons(
                                            from: xcresultPath,
                                            for: failureReport
                                        )
                                        if let crashReason = crashReason {
                                            failureReport.crashReason = crashReason
                                        }
                                    }

                                    testCase.failureReport = failureReport

                                }
                            }
                        }
                    }
                }
                summaries.append(targetViews)
            }
        }
        return summaries
    }

    /// Look for a crash reason of a failed test by xcresultPath and failureReport object
    ///  - Parameters:
    ///        - xcresultPath: Absolute path to `.xcresult` file
    ///        - failureReport: Failure report object that contains attachments. `attachment.payloadRef.id.value` will be used to extract data
    ///        - regex: Patterns to look for in a stacktrace
    ///  - Returns: `Optional String` crash reason if any.
    ///
    ///    Uses `getStacktrace` method inside and regex to
    ///     - Usage:
    ///
    ///            let crashReason = self.testsInspector.extractCrashReasons(from: xcresultPath, for: failureReport)
    public func extractCrashReasons(
        from xcresultPath: String,
        for failureReport: TestFailureReport,
        regex: [String] = [Constants.missingJsonRegex, Constants.swiftFiles]
    ) -> String? {
        guard let stacktrace = getStacktrace(from: xcresultPath, for: failureReport) else {
            return nil
        }
        let matches = regex.map { stacktrace.matches(for: $0).last }.compactMap { $0 }
        return matches.last
    }

    /// Look for an attachment named `kXCTAttachmentLegacyDiagnosticReportData`and read the contents
    ///  - Parameters:
    ///        - xcresultPath: Absolute path to `.xcresult` file
    ///        - failureReport: Failure report object that contains attachments. `attachment.payloadRef.id.value` will be used to extract data
    ///  - Returns: `Optional String` stacktrace if any.
    ///
    ///     - Usage:
    ///
    ///            let stacktrace = self.getStacktrace(from: xcresultPath, for: failureReport)
    public func getStacktrace(from xcresultPath: String, for failureReport: TestFailureReport) -> String? {

        var crashReportsIds: [String] = []

        Mirror.reflectProperties(
            of: failureReport,
            matchingType: Attachment.self,
            recursively: true
        ) { attachment in
            if let payloadId = attachment.payloadRef?.id.value,
                attachment.name.value == Constants.diagnosticsReportKey
            {
                crashReportsIds.append(payloadId)
            }
        }

        guard !crashReportsIds.isEmpty else {
            return nil
        }

        let traces = crashReportsIds.compactMap {
            try? Shell.extractStackTrace(xcresultPath: xcresultPath, id: $0)
        }
        return traces.joined(separator: "\n")
    }
}
