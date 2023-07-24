import ArgumentParser
import XCResultScrapperCore
import XCResultScrapperReport

struct CoverageCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "coverage"
    )

    @Option(help: "Path to your xcresult file")
    private var path: String

    @Option(help: "Path to your reports. Will write xml file.")
    private var outputPath: String

    @Option(help: "Report format. Available options: markdown, sonarqube, junit, console.")
    private var format: ReportFormat = .sonarqube

    func run() throws {
        let coverageScrapper = CoverageScrapper(
            scrapperConfigurator: .init(
                xcresultPath: path,
                outputPath: outputPath,
                verbose: true,
                reportFormat: format
            )
        )
        try coverageScrapper.main()
    }
}
