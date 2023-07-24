public protocol CoverageReportContainer {
    var coveredLines: Int { get }
    var executableLines: Int { get }
    var lineCoverage: Double { get}
}
