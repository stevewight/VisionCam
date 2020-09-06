import XCTest
@testable import VisionCam

final class VisionCamTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(VisionCam().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
