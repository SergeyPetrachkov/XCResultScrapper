import Foundation

// MARK: - MetaField
public struct XCMetaField: Codable {
    public let type: XCResultType
    public let value: String

    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case value = "_value"
    }
}

// MARK: - Generics
public struct TypedValuesContainer<Type: Codable, ValueType: Codable>: Codable {
    public let type: Type
    public var values: [ValueType]

    enum CodingKeys: String, CodingKey {
        case type = "_type"
        case values = "_values"
    }
}

public typealias XCValuesContainer<ValueType: Codable> = TypedValuesContainer<XCResultType, ValueType>

// MARK: - Reference
public struct XCReference: Codable {
    public let _type: XCResultType
    public let id: XCMetaField
}
