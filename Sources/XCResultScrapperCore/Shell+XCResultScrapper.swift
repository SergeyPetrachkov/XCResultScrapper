import Foundation
import XCResultScrapperDomain

enum Shell {

    enum Tools {
        static let xcrun = "/usr/bin/xcrun"
    }

    enum Errors: Int, Error, LocalizedError, CustomNSError {
        case coverageExtractionFailed = 1
        case xcresultParsingFailed
        case testsSummariesExtractionFailed
        case stacktraceExtractionFailed
        case coverageArchiveExtractionFailed

        var errorCode: Int {
            rawValue
        }

        static var errorDomain: String {
            "XCResultScrapper::Error"
        }

        var localizedDescription: String {
            switch self {
            case .coverageExtractionFailed:
                return "Failed to extract coverage report from xcresult. Try `xcrun xccov view --report --json /path/to/your/res.xcresult > ./coverage.json` in Terminal"
            case .xcresultParsingFailed:
                return "Failed to parse xcresult. Try `xcrun xcresulttool get --path /path/to/your/res.xcresult --format json` in Terminal"
            case .testsSummariesExtractionFailed:
                return "Failed to extract tests summaries from xcresult. Try `xcrun xcresulttool get --path /path/to/your/res.xcresult --format json --id {id}` in Terminal"
            case .stacktraceExtractionFailed:
                return "Failed to extract stacktrace from xcresult. Try `xcrun xcresulttool get --path /path/to/your/res.xcresult --id {id}` in Terminal"
            case .coverageArchiveExtractionFailed:
                return "Failed to extract coverage archive from xcresult. Try `xcrun xccov view --archive --json /path/to/your/res.xcresult > ./coverage.json` in Terminal"
            }
        }

        var errorDescription: String? {
            localizedDescription
        }
    }

    /// When you don't run any long processes with lots of data coming around, you can just use this method.
    @discardableResult
    static func simpleExecute(launchPath: String, arguments: [String] = []) -> Data? {
        let task = Process()
        task.launchPath = launchPath
        task.arguments = arguments

        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()

        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return data
    }

    // MARK: - Coverage

    /// Runs `xcrun xccov view --report --json /path/to/your/res.xcresult`
    /// and parses it to `CoverageReport` structure.
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    /// - Returns: Model of type `CoverageReport` containing info about targets, files, functions
    /// - Throws: Either decoding error (in case xccov format changes) or `coverageExtractionFailed`
    static func extractCoverage(xcresultPath: String) throws -> CoverageReport {
        let arguments = [
            "xccov",
            "view",
            "--report",
            "--json",
            xcresultPath
        ]
        if let coverageArchive = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        ) {
            let coverageReport = try JSONDecoder().decode(CoverageReport.self, from: coverageArchive)
            return coverageReport
        } else {
            throw Errors.coverageExtractionFailed
        }
    }

    /// Runs `xcrun xcov view --archive --json /path/to/your/res.xcresult`
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    /// - Returns: A dictionary [FilePath: Line]
    /// - Throws: `Errors.coverageArchiveExtractionFailed`
    static func extractCoverageArchive(xcresultPath: String) throws -> VerboseCoverageArchive {
        let arguments = [
            "xccov",
            "view",
            "--archive",
            "--json",
            xcresultPath
        ]
        let coverageArchiveData = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        )
        if let coverageArchiveData {
            return try JSONDecoder().decode(VerboseCoverageArchive.self, from: coverageArchiveData)
        } else {
            throw Errors.coverageArchiveExtractionFailed
        }
    }

    // MARK: - Tests

    /// Runs `xcrun xcresulttool get --path /path/to/your/res.xcresult --format json`
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    /// - Returns: Model of type `XCResult` containing xcresult contents with links to tests metadata and build info
    /// - Throws: Either decoding error (in case xcresulttool format changes) or `xcresultParsingFailed`
    static func parseXCResult(xcresultPath: String) throws -> XCResult {
        let arguments = [
            "xcresulttool",
            "get",
            "--path",
            xcresultPath,
            "--format",
            "json"
        ]

        if let xcresult = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        ) {
            let xcresult = try JSONDecoder().decode(XCResult.self, from: xcresult)
            return xcresult
        } else {
            throw Errors.xcresultParsingFailed
        }
    }

    /// Runs `xcrun xcresulttool get --path /path/to/your/res.xcresult --format json --id {id}`
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    ///     - id: Identifier or file under xcresult path. See `Ref` structures and `id` property
    /// - Returns: Model of type `XCTestResult` containing information about tests run
    /// - Throws: Either decoding error (in case xcresulttool format changes) or `testsSummariesExtractionFailed`
    static func extractTestsSummary(xcresultPath: String, id: String) throws -> XCTestResult {
        let arguments = [
            "xcresulttool",
            "get",
            "--path",
            xcresultPath,
            "--format",
            "json",
            "--id",
            id
        ]
        if let testsSummaries = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        ) {
            let testsSummaries = try JSONDecoder().decode(XCTestResult.self, from: testsSummaries)
            return testsSummaries
        } else {
            throw Errors.testsSummariesExtractionFailed
        }
    }

    /// Runs `xcrun xcresulttool export --type file --path {xcresultPath} --id {id} --output-path {directoryPath}`
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    ///     - id: Identifier or file under xcresult path. See `SummaryRef` structure and `id` property
    ///     - outputPath: Identifier or file under xcresult path. See `SummaryRef` structure and `id` property
    static func extractAttachment(xcresultPath: String, id: String, to outputPath: String) throws {
        let arguments = [
            "xcresulttool",
            "export",
            "--type",
            "file",
            "--path",
            xcresultPath,
            "--id",
            id,
            "--output-path",
            outputPath
        ]

        Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        )
    }

    static func extractFailedTestSummary(xcresultPath: String, id: String) throws -> TestFailureReport {
        let arguments = [
            "xcresulttool",
            "get",
            "--path",
            xcresultPath,
            "--format",
            "json",
            "--id",
            id
        ]
        if let testsSummaries = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        ) {
            let testsSummaries = try JSONDecoder().decode(TestFailureReport.self, from: testsSummaries)
            return testsSummaries
        } else {
            throw Errors.testsSummariesExtractionFailed
        }
    }

    /// Runs `xcrun xcresulttool get --path /path/to/your/res.xcresult --id {id}`
    /// - Parameters:
    ///     - xcresultPath: Absolute path to your xcresult
    ///     - id: Identifier or file under xcresult path. See `FailureRef` structure and `id` property
    /// - Returns: A string containing stacktrace
    /// - Throws: `Errors.stacktraceExtractionFailed`
    static func extractStackTrace(xcresultPath: String, id: String) throws -> String {
        let arguments = [
            "xcresulttool",
            "get",
            "--path",
            xcresultPath,
            "--id",
            id
        ]
        let stackTraceData = Shell.simpleExecute(
            launchPath: Tools.xcrun,
            arguments: arguments
        )
        if let stackTraceData = stackTraceData,
           let stackTrace = String(data: stackTraceData, encoding: .utf8) {
            return stackTrace
        } else {
            throw Errors.stacktraceExtractionFailed
        }
    }
}
