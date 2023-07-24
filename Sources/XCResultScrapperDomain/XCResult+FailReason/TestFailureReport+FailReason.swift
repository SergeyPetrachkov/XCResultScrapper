public extension TestFailureReport {
    /// `failureSummaries` contains "crash"
    var isCrash: Bool {
        failureSummaries.values.contains(where: { $0.message.value.lowercased().contains("crash") })
    }

    enum RuntimeProperties: String {
        case crashReason
    }

    var crashReason: String? {
        get {
            return runtimeAttributes[RuntimeProperties.crashReason.rawValue] as? String
        }
        set {
            runtimeAttributes[RuntimeProperties.crashReason.rawValue] = newValue
        }
    }
}
