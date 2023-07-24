import XCResultScrapperDomain
import XCResultScrapperReport
import Foundation

public struct CoverageScrapper: Scrapper {

    let xcresultPath: String
    let outputPath: String?
    let verbose: Bool
    let reportRenderer: ReportRendering

    public init(scrapperConfigurator: ScrapperConfigurator) {
        self.xcresultPath = scrapperConfigurator.xcresultPath
        self.outputPath = scrapperConfigurator.outputPath
        self.verbose = scrapperConfigurator.verbose
        self.reportRenderer = scrapperConfigurator.reportRenderer
    }

    public init(
        xcresultPath: String,
        outputPath: String? = nil,
        verbose: Bool = false,
        reportRenderer: ReportRendering
    ) {
        self.xcresultPath = xcresultPath
        self.outputPath = outputPath
        self.verbose = verbose
        self.reportRenderer = reportRenderer
    }

    public func main() throws {
        print("🔨 Fetching Coverage")
        let renderedReport = try generateReport(from: xcresultPath)
        let reportName = verbose ? "verbose-coverage-report" : "coverage-report"
        if let outputPath {
            try write(
                report: renderedReport,
                named: "\(reportName).\(reportRenderer.fileExtension)",
                to: outputPath
            )
        }
    }

    public func extractSwiftUIPreviews(from xcresultPath: String) throws {
        print("🔨 Fetching SwiftUI Previews Report")
        let report = try extractCoverageReport(from: xcresultPath)

        let ignoredBundle = extractIgnoredLines(from: report)

        let render = reportRenderer.render(ignoredCoverageUnits: ignoredBundle)
        if let outputPath {
            try write(report: render, named: "ignored_units.xml", to: outputPath)
        }
    }

    public func extractCoverageReport(from xcresultPath: String) throws -> CoverageReport {
        return try Shell.extractCoverage(xcresultPath: xcresultPath)
    }

    public func extractVerboseCoverage(from xcresultPath: String) throws -> VerboseCoverageArchive {
        return try Shell.extractCoverageArchive(xcresultPath: xcresultPath)
    }

    private func generateReport(from xcresultPath: String) throws -> String {
        let report = try extractCoverageReport(from: xcresultPath)
        if verbose {
            let verboseCoverage = try extractVerboseCoverage(from: xcresultPath)

            let ignoredLines = extractIgnoredLines(from: report)
            var fixedCoverage: VerboseCoverageArchive = [:]
            autoreleasepool {
                for verboseCoverageFile in verboseCoverage {
                    let commonPathToTrim = verboseCoverageFile.key.commonPrefix(with: report.targets.first?.buildProductPath ?? "")
                    let newFileName = String(verboseCoverageFile
                        .key
                        .suffix(
                            from: verboseCoverageFile.key.range(of: commonPathToTrim)?.upperBound ?? verboseCoverageFile.key.startIndex
                        ))

                    fixedCoverage[newFileName, default: []] += verboseCoverageFile
                        .value
                        .filter { lineDescriptor in
                            if let matchedIgnoreRule = ignoredLines.first(where: { verboseCoverageFile.key.hasSuffix($0.fileName) }) {
                                return !matchedIgnoreRule.lines.contains(lineDescriptor.line)
                            }
                            return true
                        }
                }
            }

            let renderedReport = reportRenderer.render(
                verboseCoverage: fixedCoverage
            )
            return renderedReport
        } else {
            let renderedReport = reportRenderer.render(
                coverageReport: report,
                config: .init(
                    minimumCoverage: 0.6,
                    excludeList: [.partialMatch(["App", "Mock", "xctest"])]
                )
            )
            return renderedReport
        }
    }

    private func extractIgnoredLines(from report: CoverageReport) -> [IgnoredCoverageUnit] {
        autoreleasepool {
            var ignoredBundle: [IgnoredCoverageUnit] = []
            for target in report.targets {
                for file in target.files {
                    // detect previews code
                    let previews = file
                        .functions
                        .filter { $0.name.hasPrefix("static") && $0.name.hasSuffix("previews.getter") }
                    if previews.isEmpty {
                        continue
                    } else {
                        // cut off the prefix that is irrelevant (up until the root of the repo)
                        let commonPathToTrim = file.path.commonPrefix(with: target.buildProductPath)
                        for function in previews {
                            let fileName = String(
                                file
                                    .path
                                    .suffix(
                                        from: file.path.range(of: commonPathToTrim)?.upperBound ?? file.path.startIndex
                                    )
                            )
                            // add each line starting from the function line number up until executableLines count
                            let linesToIgnore = Array(
                                stride(from: function.lineNumber, to: function.lineNumber + function.executableLines, by: 1)
                            )
                            
                            let ignoredUnit = IgnoredCoverageUnit(
                                fileName: fileName,
                                functionName: function.name,
                                lines: linesToIgnore
                            )
                            ignoredBundle.append(ignoredUnit)
                        }
                    }
                }
            }
            return ignoredBundle
        }
    }
}
