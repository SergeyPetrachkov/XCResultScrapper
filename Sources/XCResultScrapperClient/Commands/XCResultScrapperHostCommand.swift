import ArgumentParser
import XCResultScrapperCore

struct XCResultScrapperHostCommand: ParsableCommand {
    static var configuration: CommandConfiguration = CommandConfiguration(
        commandName: "xcresultscrapper",
        subcommands: [
            CombinedScrapperCommand.self,
            SwiftUIPreviewsExtractorCommand.self,
            CoverageCommand.self
        ],
        defaultSubcommand: CombinedScrapperCommand.self
    )
}
