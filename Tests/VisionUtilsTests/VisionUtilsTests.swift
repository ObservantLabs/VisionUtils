import Foundation
import Vision

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

  func testFaceJSOSN() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let result:String = try faceDetect(image: imageURL)
      print(result)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testNoFacesJSON() {
    guard let imageURL = Bundle.module.url(forResource: "potatoes", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let result:String = try faceDetect(image: imageURL)
      print(result)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }


  func testFacesDetect() {
    guard let imageURL = Bundle.module.url(forResource: "soccerFans", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let results:[VNFaceObservation] = try faceDetect(image: imageURL)
      XCTAssert(results.count == 2)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  func testNoFacesDetected() {
    guard let imageURL = Bundle.module.url(forResource: "potatoes", withExtension: "jpg") else {
      XCTFail("Could not find required test image to run unit tests")
      return
    }
    do {
      let results:[VNFaceObservation] = try faceDetect(image: imageURL)
      XCTAssert(results.isEmpty)
    }
    catch {
      XCTFail("error trying to run face detection")
    }
  }

  static var allTests = [
    ("testExample", testExample),
  ]
}
