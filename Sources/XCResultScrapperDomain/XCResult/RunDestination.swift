import Foundation

public struct RunDestination: Codable {
    public let _type: XCResultType
    public let displayName: XCMetaField
    public let localComputerRecord: LocalComputerRecord
    public let targetArchitecture: XCMetaField
    public let targetDeviceRecord: TargetDeviceRecord
    public let targetSDKRecord: TargetSDKRecord
}
