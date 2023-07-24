import Foundation

public struct TargetDeviceRecord: Codable {
    public let _type: XCResultType
    public let identifier: XCMetaField
    public let isConcreteDevice: XCMetaField
    public let modelCode: XCMetaField
    public let modelName: XCMetaField
    public let modelUTI: XCMetaField
    public let name: XCMetaField
    public let nativeArchitecture: XCMetaField
    public let operatingSystemVersion: XCMetaField
    public let operatingSystemVersionWithBuildNumber: XCMetaField
    public let platformRecord: PlatformRecord
}
