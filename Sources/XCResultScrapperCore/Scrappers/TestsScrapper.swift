import Foundation
import XCResultScrapperReport

/// This class combines parsing, inspecting and reporting logic. A kind of a usecase.
///
/// Since I don't plan to support anything else but Junit and XC format, you won't find Protocols and generics here :)
public struct TestsScrapper: Scrapper {

    private let xcresultPath: String
    private let outputPath: String?

    private let parser: XCResultParser
    private let testsInspector: TestsInspector
    private let reportRenderer: ReportRendering

    public init(
        scrapperConfigurator: ScrapperConfigurator,
        parser: XCResultParser = XCResultParser(),
        testsInspector: TestsInspector = TestsInspector()
    ) {
        self.xcresultPath = scrapperConfigurator.xcresultPath
        self.outputPath = scrapperConfigurator.outputPath
        self.reportRenderer = scrapperConfigurator.reportRenderer
        self.parser = parser
        self.testsInspector = testsInspector
    }

    public func main() throws {
        let testResults = try parser.extractResults(from: xcresultPath)
        let report = testsInspector.examine(bundle: testResults)

        let renderedReports = reportRenderer.render(testsRunReport: report)
        if let outputPath,
            !reportRenderer.fileExtension.isEmpty
        {
            for renderedReport in renderedReports.enumerated() {
                try write(report: renderedReport.element, named: "TestsReport_\(renderedReport.offset).\(reportRenderer.fileExtension)", to: outputPath)
            }
        } else {
            renderedReports.forEach { print($0) }
        }
    }
}
