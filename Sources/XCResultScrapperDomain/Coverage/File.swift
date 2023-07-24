public struct File: Codable, TitledCoverageReportContainer, CoverageReportParent {
    // MARK: - TitledCoverageReportContainer
    public let name: String
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    // MARK: - Own props
    public let functions: [Function]
    public let path: String
}

public extension File {
    var children: [TitledCoverageReportContainer] {
        functions
    }
}
