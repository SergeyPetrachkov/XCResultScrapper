import Foundation

// MARK: - XCResult
public struct XCResult: Codable {
    public let _type: XCResultType
    public let actions: Actions
    public let issues: XCResultIssues
    public let metadataRef: MetadataRefClass
    public let metrics: XCResultMetrics
}

// MARK: - Actions
public typealias Actions = XCValuesContainer<ActionsValue>

// MARK: - ActionsValue

public struct ActionsValue: Codable {
    public let _type: XCResultType
    public let actionResult: ActionResult
    public let buildResult: BuildResult
    public let endedTime: XCMetaField
    public let runDestination: RunDestination
    public let schemeCommandName: XCMetaField
    public let schemeTaskName: XCMetaField
    public let startedTime: XCMetaField
    public let title: XCMetaField?
}

// MARK: - ActionResult

public struct ActionResult: Codable {
    public let _type: XCResultType
    public let coverage: Coverage
    public let issues: CoverageClass
    public let metrics: ActionResultMetrics
    public let resultName: XCMetaField
    public let status: XCMetaField
    public let diagnosticsRef: DiagnosticsRefClass?
    public let logRef: MetadataRefClass?
    public let testsRef: MetadataRefClass?
}

// MARK: - Coverage

public struct Coverage: Codable {
    public let _type: XCResultType
    public let archiveRef: DiagnosticsRefClass?
    public let hasCoverageData: XCMetaField?
    public let reportRef: DiagnosticsRefClass?
}

// MARK: - DiagnosticsRefClass

public typealias DiagnosticsRefClass = XCReference

// MARK: - CoverageClass

public struct CoverageClass: Codable {
    public let _type: XCResultType
}

// MARK: - MetadataRefClass

public struct MetadataRefClass: Codable {
    public let _type: XCResultType
    public let id: XCMetaField
    public let targetType: TargetType
}

// MARK: - TargetType

public struct TargetType: Codable {
    public let _type: XCResultType
    public let name: XCMetaField
}

// MARK: - ActionResultMetrics

public struct ActionResultMetrics: Codable {
    public let _type: XCResultType
    public let testsCount: XCMetaField?
}

// MARK: - BuildResult

public struct BuildResult: Codable {
    public let _type: XCResultType
    public let coverage: CoverageClass
    public let issues: XCResultIssues
    public let logRef: MetadataRefClass?
    public let metrics: BuildResultMetrics
    public let resultName: XCMetaField
    public let status: XCMetaField
}

// MARK: - XCResultIssues

public struct XCResultIssues: Codable {
    public let _type: XCResultType
    public let warningSummaries: WarningSummaries?
}

// MARK: - WarningSummaries
public typealias WarningSummaries = XCValuesContainer<WarningSummariesValue>

// MARK: - WarningSummariesValue

public struct WarningSummariesValue: Codable {
    public let _type: XCResultType
    public let issueType: XCMetaField
    public let message: XCMetaField
    public let documentLocationInCreatingWorkspace: DocumentLocationInCreatingWorkspace?
}

// MARK: - DocumentLocationInCreatingWorkspace

public struct DocumentLocationInCreatingWorkspace: Codable {
    public let _type: XCResultType
    public let concreteTypeName, url: XCMetaField
}

// MARK: - BuildResultMetrics

public struct BuildResultMetrics: Codable {
    public let _type: XCResultType
    public let warningCount: XCMetaField?
}

// MARK: - PlatformRecord

public struct PlatformRecord: Codable {
    public let _type: XCResultType
    public let identifier: XCMetaField
    public let userDescription: XCMetaField
}

// MARK: - TargetSDKRecord

public struct TargetSDKRecord: Codable {
    public let _type: XCResultType
    public let identifier: XCMetaField
    public let name: XCMetaField
    public let operatingSystemVersion: XCMetaField
}

// MARK: - XCResultMetrics

public struct XCResultMetrics: Codable {
    public let _type: XCResultType
    public let testsCount: XCMetaField
    public let warningCount: XCMetaField?
}
