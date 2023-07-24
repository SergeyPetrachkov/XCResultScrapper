import ArgumentParser
import XCResultScrapperCore
import XCResultScrapperReport

struct CombinedScrapperCommand: ParsableCommand {

    static let configuration = CommandConfiguration(commandName: "scrap")

    @Option(help: "Path to your xcresult file")
    private var path: String

    @Option(help: "Path to your reports. Optional. Will write xml/md files if provided.")
    private var outputPath: String?

    @Option(wrappedValue: false, help: "Specify if you want to fetch tests coverage")
    private var fetchCoverage: Bool

    @Option(help: "Report format. Available options: markdown, sonarqube, junit, console.")
    private var format: ReportFormat = .markdown

    func run() throws {

        let testsScrapper = TestsScrapper(
            scrapperConfigurator: .init(
                xcresultPath: path,
                outputPath: outputPath,
                reportFormat: .markdown
            )
        )
        try testsScrapper.main()

        if fetchCoverage {
            let coverageScrapper = CoverageScrapper(
                scrapperConfigurator: .init(
                    xcresultPath: path,
                    outputPath: outputPath,
                    verbose: false,
                    reportFormat: format
                )
            )
            try coverageScrapper.main()
        }
    }
}
