import XCResultScrapperDomain
import SwiftyXML
import Foundation

public struct SonarQubeRenderer: ReportRendering {
    public var fileExtension: String {
        "xml"
    }

    public init() {

    }

    public func render(testsRunReport: TestsRunReport) -> [String] {
        []
    }

    public func render(coverageReport: CoverageReport, config: CoverageReportRenderingConfig) -> String {
        // TODO: this is not working, we need to execute another query to xcresult
        // xcrun xccov view --archive /path.xcresult --json
        let coverageXML = XML(name: "coverage", attributes: ["version": 1])
        let allFiles = coverageReport.targets.flatMap(\.files)

        allFiles.forEach { file in
            let fileXML = XML(name: "file", attributes: ["path": file.path])
            file.functions.forEach { function in
                
            }
            coverageXML.addChild(fileXML)
        }
        let header = "<?xml version=\"1.0\"?>\n"
        let xml = coverageXML.toXMLString()
        return header+xml
    }

    public func render(verboseCoverage: VerboseCoverageArchive) -> String {
        let coverageXML = XML(name: "coverage", attributes: ["version": 1])
        autoreleasepool {
            verboseCoverage.forEach { (file, lines) in
                let fileXML = XML(name: "file", attributes: ["path": file])
                lines.forEach { line in
                    let lineXML = XML(name: "lineToCover")
                    lineXML.addAttribute(name: "lineNumber", value: "\(line.line)")
                    lineXML.addAttribute(name: "covered", value: "\(line.isCovered)")
                    fileXML.addChild(lineXML)
                }
                coverageXML.addChild(fileXML)
            }
        }
        let header = "<?xml version=\"1.0\"?>\n"
        let xml = coverageXML.toXMLString()
        return header+xml
    }

    public func render(ignoredCoverageUnits: [IgnoredCoverageUnit]) -> String {
        let coverageXML = XML(name: "excluded_from_coverage", attributes: ["version": 1])
        ignoredCoverageUnits.forEach { ignored in
            let fileXML = XML(
                name: "file",
                attributes: [
                    "path": ignored.fileName,
                    "function": ignored.functionName,
                ]
            )
            ignored.lines.forEach { line in
                let lineToCoverXML = XML(name: "lineToCover", attributes: ["lineNumber": line])
                fileXML.addChild(lineToCoverXML)
            }
            coverageXML.addChild(fileXML)
        }
        let header = "<?xml version=\"1.0\"?>\n"
        let xml = coverageXML.toXMLString()
        return header+xml
    }
}
