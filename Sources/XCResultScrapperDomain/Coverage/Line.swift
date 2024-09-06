import Foundation

public struct Line: Decodable {

    public struct Subrange: Decodable {
        public let column: Int
        public let executionCount: Int?
        public let length: Int

        public enum CodingKeys: CodingKey {
            case column
            case executionCount
            case length
        }

        public init(from decoder: any Decoder) throws {
            let container: KeyedDecodingContainer<Line.Subrange.CodingKeys> = try decoder.container(keyedBy: Line.Subrange.CodingKeys.self)
            self.column = try container.decode(Int.self, forKey: Line.Subrange.CodingKeys.column)
            self.executionCount = try? container.decodeIfPresent(Int.self, forKey: Line.Subrange.CodingKeys.executionCount) ?? 0
            self.length = try container.decode(Int.self, forKey: Line.Subrange.CodingKeys.length)
        }
    }

    public let line: Int
    public let isExecutable: Bool
    public let executionCount: Int?
    public let subranges: [Subrange]?

    public var isCovered: Bool {
        isExecutable && (executionCount ?? 0) > 0
    }

    public enum CodingKeys: CodingKey {
        case line
        case isExecutable
        case executionCount
        case subranges
    }

    public init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.line = try container.decode(Int.self, forKey: .line)
        self.isExecutable = try container.decode(Bool.self, forKey: .isExecutable)
        self.executionCount = try? container.decodeIfPresent(Int.self, forKey: .executionCount) ?? 0
        self.subranges = try container.decodeIfPresent([Line.Subrange].self, forKey: .subranges)
    }
}
