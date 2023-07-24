public struct TestsSuiteSummary {
    public var testClasses: [TestClass]
    public let duration: Double

    public init(from xcTestClassesBundle: TestClassesBundle) {
        self.testClasses = xcTestClassesBundle.values
        self.duration = self.testClasses.compactMap { Double($0.duration?.value ?? "0") }.reduce(0, +)
    }
}
