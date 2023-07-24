import Foundation

// MARK: - TypeClass
public struct XCResultType: Codable {
    public let name: XCResultTypeName

    enum CodingKeys: String, CodingKey {
        case name = "_name"
    }
}

public enum XCResultTypeName: String, Codable {
    case actionDeviceRecord = "ActionDeviceRecord"
    case actionPlatformRecord = "ActionPlatformRecord"
    case actionRecord = "ActionRecord"
    case actionResult = "ActionResult"
    case actionRunDestinationRecord = "ActionRunDestinationRecord"
    case actionSDKRecord = "ActionSDKRecord"
    case actionsInvocationRecord = "ActionsInvocationRecord"
    case array = "Array"
    case bool = "Bool"
    case codeCoverageInfo = "CodeCoverageInfo"
    case date = "Date"
    case documentLocation = "DocumentLocation"
    case int = "Int"
    case double = "Double"
    case issueSummary = "IssueSummary"
    case reference = "Reference"
    case resultIssueSummaries = "ResultIssueSummaries"
    case resultMetrics = "ResultMetrics"
    case string = "String"
    case typeDefinition = "TypeDefinition"
    case actionAbstractTestSummary = "ActionAbstractTestSummary"
    case actionTestPlanRunSummaries = "ActionTestPlanRunSummaries"
    case actionTestMetadata = "ActionTestMetadata"
    case actionTestSummaryGroup = "ActionTestSummaryGroup"
    case actionTestPlanRunSummary = "ActionTestPlanRunSummary"
    case actionTestSummaryIdentifiableObject = "ActionTestSummaryIdentifiableObject"
    case actionTestableSummary = "ActionTestableSummary"
    case actionTestActivitySummary = "ActionTestActivitySummary"
    case actionTestAttachment = "ActionTestAttachment"
    case actionTestFailureSummary = "ActionTestFailureSummary"
    case actionTestSummary = "ActionTestSummary"
}
