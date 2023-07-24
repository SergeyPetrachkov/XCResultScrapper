import Foundation

public struct CoverageReport: Codable, TitledCoverageReportContainer, CoverageReportParent {
    // MARK: - CoverageReportContainer
    public let coveredLines: Int
    public let executableLines: Int
    public let lineCoverage: Double
    // MARK: - Own props
    public let targets: [Target]
}

public extension CoverageReport {
    var name: String {
        "Coverage Report Summary"
    }
}

public extension CoverageReport {
    var children: [TitledCoverageReportContainer] {
        targets
    }
}
