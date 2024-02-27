import Foundation

public protocol Scrapper {

}

public extension Scrapper {
    func write(report: String, named name: String, to outputPath: String) throws {
        let outputDirectoryUrl = URL(fileURLWithPath: outputPath, isDirectory: true)
        let url = outputDirectoryUrl.appendingPathComponent(name)
        if let data = report.data(using: .utf8) {
            try FileManager.default.createDirectory(
                at: url.deletingLastPathComponent(),
                withIntermediateDirectories: true,
                attributes: nil
            )

            if FileManager.default.createFile(
                atPath: url.path,
                contents: data,
                attributes: nil
            ) {
                print("✅ XCResultScrapper wrote to \(url.path)")
            } else {
                print("❌ XCResultScrapper failed to write to \(url.path)")
            }
        }
    }
}
