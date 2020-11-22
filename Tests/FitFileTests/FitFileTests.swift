import XCTest
@testable import FitFile

final class FitFileTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(FitFile().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
