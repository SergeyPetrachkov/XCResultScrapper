import XCResultScrapperDomain

public protocol ReportRendering {

    var fileExtension: String { get }

    func render(testsRunReport: TestsRunReport) -> [String]
    func render(coverageReport: CoverageReport, config: CoverageReportRenderingConfig) -> String
    func render(verboseCoverage: VerboseCoverageArchive) -> String
    func render(ignoredCoverageUnits: [IgnoredCoverageUnit]) -> String
}

extension ReportRendering {
    public var fileExtension: String {
        ""
    }

    public func render(testsRunReport: TestsRunReport) -> [String] {
        []
    }

    public func render(coverageReport: CoverageReport, config: CoverageReportRenderingConfig) -> String {
        ""
    }

    public func render(ignoredCoverageUnits: [IgnoredCoverageUnit]) -> String {
        ""
    }

    public func render(verboseCoverage: VerboseCoverageArchive) -> String {
        ""
    }
}
