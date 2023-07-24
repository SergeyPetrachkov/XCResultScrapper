import Foundation

public extension NumberFormatter {
    static let percentageReportFormatter: NumberFormatter = {
        let percentFormatter = NumberFormatter()
        percentFormatter.numberStyle = NumberFormatter.Style.percent
        percentFormatter.minimumFractionDigits = 1
        percentFormatter.maximumFractionDigits = 2
        return percentFormatter
    }()
}
