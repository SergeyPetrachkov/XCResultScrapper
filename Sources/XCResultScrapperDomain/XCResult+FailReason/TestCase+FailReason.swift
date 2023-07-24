public extension TestCase {
    /// Testcase contains `crash`
    ///
    /// See `TestFailureReport.isCrashed`
    var isCrash: Bool {
        failureReport?.isCrash ?? false
    }

    /// Test failed and contains `Lost connection to the application`
    ///
    /// Might be recoverable, if it's a simulator failure, so might be rerun.
    var lostConnectionToApp: Bool {
        failureReport?.failureSummaries.values.contains(where: { $0.message.value.contains("Lost connection to the application") }) ?? false
    }

    /// Test failed and contains a message about lost connection to a helper application
    var simulatorHang: Bool {
        failureReport?.failureSummaries.values.contains(where: { $0.message.value.contains("Could not communicate with a helper application") }) ?? false
    }

    /// Failed because of `Assertion Failure`
    ///
    /// Expensive operation. See `assertionReason`.
    var isAssertionFailure: Bool {
        assertionReason != nil
    }

    /// Assertion reason if any.
    ///
    /// Expensive operation because we have to go though activitySummaries array and for each of activitySummary to go through subactivities array.
    var assertionReason: String? {
        let assertionInfo: [String]? = self.failureReport?.activitySummaries?.values.compactMap { values in
            let assertion = values.subactivities?.values.last { subactivity in
                if let title = subactivity.title {
                    return title.value.lowercased().contains("assert")
                }
                return false
            }

            if let assertion = assertion, let title = assertion.title {
                return "\(title.value) \(title.value)"
            }
            return nil
        }
        return assertionInfo?.last
    }
}
