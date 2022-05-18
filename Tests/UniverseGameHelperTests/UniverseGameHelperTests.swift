import XCTest
@testable import UniverseGameHelper
import SwiftUI

final class UniverseGameHelperTests: XCTestCase {
    func testExample() throws {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        print(Color.fromHex(hexString: "ff00000").toHex())
        print(Color.fromHex(hexString: "0000000").cgColor?.components)
    }
}
