import XCResultScrapperDomain

public struct ConsoleRenderer: ReportRendering {

    public init() {}

    public func render(from input: TestTargetSummary) -> String {
        ""
    }

    public func render(testsRunReport: TestsRunReport) -> [String] {
        if testsRunReport.noFailures {
            return ["✅ All good! 🚀"]
        } else {
            var result = "❌ Failed tests:\n"
            result += testsRunReport
                .allFailures
                .map { test in
                    "\(test.name.value)"
                }
                .joined(separator: "\n")
            return [result]
        }
    }

    public func render(coverageReport: CoverageReport, config: CoverageReportRenderingConfig) -> String {
        var result = coverageReport.coverageSummary + "\n"
        result += coverageReport
            .children
            .map { "\u{2022} \($0.coverageSummary) \($0.lineCoverage > config.minimumCoverage ? "✅" : "⚠️")" }
            .joined(separator: "\n")
        return result
    }
}
