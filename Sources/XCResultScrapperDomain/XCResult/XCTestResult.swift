import Foundation

// MARK: - XCTestResult
public struct XCTestResult: Codable {
    public let _type: XCResultType
    public let summaries: Summaries
}

// MARK: - Summaries
public typealias Summaries = XCValuesContainer<SummariesValue>

// MARK: - SummariesValue
public struct SummariesValue: Codable {
    public let _type: ValueSupertype
    public let name: XCMetaField
    public let testableSummaries: TestableSummaries
}

// MARK: - TestableSummaries
public typealias TestableSummaries = XCValuesContainer<TestableTargetSummary>

// MARK: - TestableSummariesValue
public struct TestableTargetSummary: Codable {
    let _type: ValueSupertype
    let diagnosticsDirectoryName: XCMetaField
    let name: XCMetaField
    let targetName: XCMetaField
    let projectRelativePath: XCMetaField?
    let testKind: XCMetaField
    var tests: Tests
}

public extension Collection where Self == [TestClass] {
    func flatten() -> [TestCase] {
        self.reduce([TestCase](), { $0 + $1.subtests.values })
    }
}

// MARK: - Tests
public typealias Tests = XCValuesContainer<TestsValue>

// MARK: - TestsValue

public struct TestsValue: Codable {
    public let _type: XCResultType
    public let duration: XCMetaField?
    public let identifier: XCMetaField
    public let name: XCMetaField
    public var subtests: TestsSuite?
}

// MARK: - SubtestsBundle
public typealias TestsSuite = XCValuesContainer<TestValue>

// MARK: - TestValue

public struct TestValue: Codable {
    public let _type: XCResultType
    public let duration: XCMetaField?
    public let identifier: XCMetaField?
    public let name: XCMetaField?
    public let subtests: TestClassesBundle?
}

// MARK: - TestClassesBundle

public typealias TestClassesBundle = XCValuesContainer<TestClass>

// MARK: - TestClass

public struct TestClass: Codable {
    public let _type: XCResultType
    public let duration: XCMetaField?
    public let identifier, name: XCMetaField
    public var subtests: TestCasesBundle
}

// MARK: - TestCasesBundle
public typealias TestCasesBundle = XCValuesContainer<TestCase>

// MARK: - TestCase
public struct TestCase: Codable {

    public let _type: XCResultType
    public let duration: XCMetaField?
    public let identifier: XCMetaField
    public let name: XCMetaField
    public let summaryRef: SummaryRef?
    public let testStatus: XCMetaField

    /// Make additional request by `self.summaryRef.id.value` to retrieve this value from xcresult
    public var failureReport: TestFailureReport?

    mutating func with(failureReport: TestFailureReport) -> Self {
        self.failureReport = failureReport
        return self
    }

    public var resolvedDuration: Double {
        guard let value = self.duration?.value else {
            return 0
        }
        return Double(value) ?? 0
    }

    public var failureMessage: String {
        failureReport?
            .failureSummaries
            .values
            .map(\.message.value)
            .joined(separator: ";")
            .replacingOccurrences(of: "\n", with: "") ?? "N/A"
    }
}

// MARK: - SummaryRef

public struct SummaryRef: Codable {
    public let _type: XCResultType
    public let id: XCMetaField
    public let targetType: TargetType
}

// MARK: - ValueSupertype

public struct ValueSupertype: Codable {
    public let name: XCResultTypeName
    public let supertype: XCResultType

    enum CodingKeys: String, CodingKey {
        case name = "_name"
        case supertype = "_supertype"
    }
}

// MARK: - ActivitySummariesValue

public struct ActivitySummariesValue: Codable {
    public let _type: XCResultType
    public let activityType: XCMetaField
    public let attachments: Attachments?
    public let finish, start: XCMetaField?
    public let title, uuid: XCMetaField?
    public let subactivities: XCValuesContainer<ActivitySummariesValue>?
}

// MARK: - TestFailureReport

public struct TestFailureReport: Codable {
    public let _type: XCResultType
    public let activitySummaries: XCValuesContainer<ActivitySummariesValue>?
    public let failureSummaries: XCValuesContainer<FailureSummary>
    public let duration: XCMetaField?
    public let identifier, name, testStatus: XCMetaField

    enum CodingKeys: String, CodingKey {
        case _type
        case activitySummaries
        case failureSummaries
        case duration
        case identifier
        case name
        case testStatus
    }

    /// Attach any runtime info, that you extract while going through an xcreult file, here
    public var runtimeAttributes: [String: Any] = [:]
}

// MARK: - FailureSummariesValue

public struct FailureSummary: Codable {
    public let _type: XCResultType
    public let fileName: XCMetaField?
    public let message: XCMetaField
    public let lineNumber: XCMetaField?
}

// MARK: - Attachments

public typealias Attachments = XCValuesContainer<Attachment>

// MARK: - AttachmentsValue

public struct Attachment: Codable {
    public let _type: XCResultType
    public let filename, inActivityIdentifier, lifetime, name: XCMetaField
    public let payloadRef: PayloadRef?
    public let payloadSize, timestamp, uniformTypeIdentifier: XCMetaField
}

// MARK: - PayloadRef

public typealias PayloadRef = DiagnosticsRefClass
