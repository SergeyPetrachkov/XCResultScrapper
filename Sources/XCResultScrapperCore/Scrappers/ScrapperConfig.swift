import XCResultScrapperReport

public struct ScrapperConfigurator {

    public let xcresultPath: String
    public let outputPath: String?
    public let verbose: Bool
    public let reportFormat: ReportFormat

    public var reportRenderer: ReportRendering {
        switch reportFormat {
        case .console:
            return ConsoleRenderer()
        case .junit:
            return JunitRenderer()
        case .markdown:
            return MarkdownRenderer()
        case .sonarqube:
            return SonarQubeRenderer()
        }
    }

    public init(
        xcresultPath: String,
        outputPath: String? = nil,
        verbose: Bool = false,
        reportFormat: ReportFormat
    ) {
        self.xcresultPath = xcresultPath
        self.outputPath = outputPath
        self.verbose = verbose
        self.reportFormat = reportFormat
    }
}
