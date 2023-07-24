public struct Function: Codable, TitledCoverageReportContainer {
    // MARK: - TitledCoverageReportContainer
    public let name: String
    public let coveredLines: Int
    public let executableLines: Int
    // MARK: - Own props
    public let lineNumber: Int
    public let executionCount: Int
    public let lineCoverage: Double
}
