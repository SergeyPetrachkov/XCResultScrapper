public struct Target: Codable, TitledCoverageReportContainer, CoverageReportParent {
    public let name: String
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    // MARK: - Own props
    public let buildProductPath: String
    public let files: [File]
}

public extension Target {
    var children: [TitledCoverageReportContainer] {
        files
    }
}
