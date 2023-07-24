import Foundation

public struct LocalComputerRecord: Codable {
    public let _type: XCResultType
    public let busSpeedInMHz: XCMetaField?
    public let cpuCount: XCMetaField
    public let cpuKind: XCMetaField
    public let cpuSpeedInMHz: XCMetaField?
    public let identifier: XCMetaField
    public let isConcreteDevice: XCMetaField
    public let logicalCPUCoresPerPackage: XCMetaField
    public let modelCode: XCMetaField
    public let modelName: XCMetaField
    public let modelUTI: XCMetaField
    public let name: XCMetaField
    public let nativeArchitecture: XCMetaField
    public let operatingSystemVersion: XCMetaField
    public let operatingSystemVersionWithBuildNumber: XCMetaField
    public let physicalCPUCoresPerPackage: XCMetaField
    public let platformRecord: PlatformRecord
    public let ramSizeInMegabytes: XCMetaField
}
