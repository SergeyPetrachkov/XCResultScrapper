public struct CoverageReportRenderingConfig {

    public enum ExclusionKind {
        case exactMatch([String])
        case partialMatch([String])
    }

    public let minimumCoverage: Double
    public let excludeList: [ExclusionKind]

    public init(minimumCoverage: Double, excludeList: [ExclusionKind] = []) {
        self.minimumCoverage = minimumCoverage
        self.excludeList = excludeList
    }

    public static func `default`() -> Self {
        .init(
            minimumCoverage: 0.5,
            excludeList: []
        )
    }
}
