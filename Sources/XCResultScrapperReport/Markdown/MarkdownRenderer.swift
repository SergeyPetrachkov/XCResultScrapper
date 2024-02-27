import XCResultScrapperDomain

public struct MarkdownRenderer: ReportRendering {

    public var fileExtension: String {
        "md"
    }

    public init() {}

    public func render(testsRunReport: TestsRunReport) -> [String] {
        if testsRunReport.allFailures.isEmpty {
            return [
                """
                ## Tests run report:

                ✅ All good here! 🚀
                """
            ]
        } else {

            var result: [String] = []
            var markdown = headerForAllTests()

            markdown += testsRunReport
                .allFailures
                .map { test in
                    "\(test.name.value) | \(test.duration?.value ?? "N/A") | \(test.assertionReason ?? test.failureReport?.crashReason ?? test.failureMessage)"
                }
                .joined(separator: "\n")

            result.append(markdown)

            if !testsRunReport.crashedTests.isEmpty {
                var markdown = headerForCrashedTests()
                markdown += testsRunReport
                    .crashedTests
                    .map { test in
                        "\(test.name.value) | \(test.duration?.value ?? "N/A") | \(test.failureReport?.crashReason ?? test.failureMessage)"
                    }
                    .joined(separator: "\n")
                result.append(markdown)
            }

            if !testsRunReport.assertionFailures.isEmpty {
                var markdown = headerForAssertionFailures()
                markdown += testsRunReport
                    .assertionFailures
                    .map { test in
                        "\(test.name.value) | \(test.duration?.value ?? "N/A") | \(test.assertionReason ?? test.failureMessage)"
                    }
                    .joined(separator: "\n")
                result.append(markdown)
            }

            return result
        }
    }

    public func render(coverageReport: CoverageReport, config: CoverageReportRenderingConfig) -> String {
        var markdown = "## Coverage report\n"

        markdown += """
            | Target | Coverage | Status |
            | --- | --- | --- |\n
            """

        markdown += coverageReport
            .children
            .compactMap { target in
                for excludeList in config.excludeList {
                    switch excludeList {
                    case .exactMatch(let array):
                        if array.contains(target.name) {
                            return nil
                        }
                    case .partialMatch(let array):
                        if array.contains(where: { target.name.contains($0) }) {
                            return nil
                        }
                    }
                }
                return "\(target.name) | \(target.formattedCoveragePercentage) | \(target.lineCoverage > config.minimumCoverage ? "✅" : "⚠️")\n"
            }
            .joined()

        return markdown
    }

    private func headerForAllTests() -> String {
        """
        ## Tests run report:
        | Test | Duration | Fail Reason |
        | --- | --- | --- |\n
        """
    }

    private func headerForCrashedTests() -> String {
        """
        ## Crashed Tests:
        | Test | Duration | Fail Reason |
        | --- | --- | --- |\n
        """
    }

    private func headerForAssertionFailures() -> String {
        """
        ## Assertion Failures:
        | Test | Duration | Fail Reason |
        | --- | --- | --- |\n
        """
    }
}
