import XCTest

#if !canImport(ObjectiveC)
public func allTests() -> [XCTestCaseEntry] {
    return [
        testCase(string_obfuscatorTests.allTests),
    ]
}
#endif
