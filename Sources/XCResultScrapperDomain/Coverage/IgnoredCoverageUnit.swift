public struct IgnoredCoverageUnit {
    public let fileName: String
    public let functionName: String
    public let lines: [Int]

    public init(fileName: String, functionName: String, lines: [Int]) {
        self.fileName = fileName
        self.functionName = functionName
        self.lines = lines
    }
}
