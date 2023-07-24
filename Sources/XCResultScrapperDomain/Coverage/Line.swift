import Foundation

public struct Line: Decodable {

    public struct Subrange: Decodable {
        public let column: Int
        public let executionCount: Int?
        public let length: Int
    }

    public let line: Int
    public let isExecutable: Bool
    public let executionCount: Int?
    public let subranges: [Subrange]?

    public var isCovered: Bool {
        isExecutable && (executionCount ?? 0) > 0
    }
}
