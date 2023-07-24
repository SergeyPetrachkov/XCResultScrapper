import XCResultScrapperUtils
import Foundation

public protocol TitledCoverageReportContainer: NamedModel, CoverageReportContainer { }

public extension TitledCoverageReportContainer {
    var coverageSummary: String {
        "\(name): \(formattedCoveragePercentage)"
    }

    var formattedCoveragePercentage: String {
        NumberFormatter.percentageReportFormatter.string(from: NSNumber(value: lineCoverage)) ?? "\(lineCoverage)"
    }
}
