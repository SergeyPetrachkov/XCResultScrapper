import ArgumentParser
import XCResultScrapperCore
import XCResultScrapperReport

struct SwiftUIPreviewsExtractorCommand: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "extract-swiftui-previews-coverage"
    )

    @Option(help: "Path to your xcresult file")
    private var path: String

    @Option(help: "Path to your reports. Will write xml file.")
    private var outputPath: String

    func run() throws {
        let coverageScrapper = CoverageScrapper(
            xcresultPath: path,
            outputPath: outputPath,
            reportRenderer: SonarQubeRenderer()
        )
        try coverageScrapper.extractSwiftUIPreviews(from: path)
    }
}
