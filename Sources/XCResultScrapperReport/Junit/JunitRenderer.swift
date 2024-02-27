import SwiftyXML
import XCResultScrapperDomain
import Foundation

public struct JunitRenderer: ReportRendering {

    let dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        let enUSPosixLocale = Locale(identifier: "en_US_POSIX")
        dateFormatter.locale = enUSPosixLocale
        dateFormatter.calendar = Calendar(identifier: .gregorian)
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
        return dateFormatter
    }()

    public var fileExtension: String {
        "xml"
    }

    public init() {}

    public func render(from input: TestTargetSummary) -> String {
        let target = input
        let sessionXML = XML(name: "testsuites")

        let suites = target.suites
        let totalTestsCount = suites.flatMap { $0.testClasses.flatten() }.count
        let failedTestsCount = target.allFailedTests().count
        sessionXML.addAttributes(
            [
                "tests": totalTestsCount,
                "failures": failedTestsCount
            ]
        )
        suites.forEach { suite in

            let suiteXML = XML(name: "testsuite")
            let classes = suite.testClasses
            let allCases = classes.flatMap { $0.subtests.values }
            suiteXML.addAttributes(
                [
                    "name": target.targetName.value,
                    "tests": allCases.count,
                    "failures": allCases.filter { $0.testStatus.value == TestResult.failure.rawValue }.count,
                    "time": suite.duration
                ]
            )

            classes.forEach { testClass in
                testClass.subtests.values.forEach { testCase in
                    let caseXML = XML(name: "testcase")
                    caseXML.addAttributes(
                        [
                            "classname": testClass.name.value,
                            "name": testCase.name.value,
                            "time": testCase.resolvedDuration
                        ]
                    )
                    if testCase.testStatus.value == TestResult.failure.rawValue {
                        let failureXML = XML(name: "failure")
                        if let failureReport = testCase.failureReport,
                            let lastSummary = failureReport.failureSummaries.values.last
                        {

                            var message = "\(lastSummary.message.value) File=\(lastSummary.fileName?.value ?? "<nil>"); "
                            if let lineNumber = lastSummary.lineNumber?.value {
                                message += "Line=\(lineNumber); "
                            }

                            if let assertionReason = testCase.assertionReason {
                                message += "Assertion Details: \(assertionReason.prefix(250))"
                            }

                            if let crashReason = failureReport.crashReason {
                                message += "Crash Reason: \(crashReason)"
                            }

                            failureXML.addAttribute(name: "message", value: message)
                        }
                        caseXML.addChild(failureXML)
                    }
                    suiteXML.addChild(caseXML)
                }
            }
            sessionXML.addChild(suiteXML)
        }
        let header = "<?xml version=\"1.0\" encoding=\"UTF-8\"?>\n"
        let xml = sessionXML.toXMLString()
        return header + xml
    }
}
