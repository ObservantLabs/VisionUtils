import Foundation
import XCTest
@testable import VisionUtils

final class VisionUtilsTests: XCTestCase {
  func testExample() {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct
    // results.
    XCTAssertEqual(DummyStruct().text, "Hello, world")
  }

  func testImagePresent() {
    let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg")
    XCTAssert(imageURL != nil)
  }

  func testFaceDetect() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let result = try faceDetect(image: imageURL)
      print(result)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }
  static var allTests = [
    ("testExample", testExample),
  ]
}
