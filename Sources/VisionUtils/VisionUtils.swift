import Foundation
import Vision

private func MyLog(_ message:String) {
  NSLog("%@",message)
}

internal struct DummyStruct {
  var text:String = "Hello, world"
}

enum DetectionError : Error {
  /// Apple API reports an error (not just no face) during face detection
  case appleErrorDetection(error:NSError)
  /// Apple API violates its contract and returns an unexpected VNObservation subtype which is not VNFaceObsercation
  case appleErrorObservationType
  /// Apple API violates its contract in some other way
  case appleErrorMisc
  /// Programming error in our own implementation of  Encodable for VNFaceObservation. Should never happen
  case jsonEncodingError
}

/// Synchronously runs face detection only and returns JSON-encoded results
/// - Parameter image: URL to an image
/// - Returns: String with a JSON array with face detection results
public func faceDetect(image:URL) throws -> String
{
  // detect faces
  let fdRequestHandler = VNSequenceRequestHandler()
  let fdRequest = VNDetectFaceRectanglesRequest()
  do {
    try fdRequestHandler.perform([fdRequest],
                                 onImageURL: image)
  }
  catch let e as NSError {
    throw DetectionError.appleErrorDetection(error: e)
  }
  catch {
    // Apple's Vision threw a non-NSSError error object. Should never happen
    throw DetectionError.appleErrorMisc
  }

  // safe b/c Apple API promises this result type for a VNDetectFaceRectanglesRequest request
  guard let faceDetectionObservations = fdRequest.results as? [VNFaceObservation] else {
    throw DetectionError.appleErrorObservationType
  }

  let jsonEncoder = JSONEncoder()
  let jsons = try faceDetectionObservations.map {
    (vnfo:VNFaceObservation) -> String in
    guard let d = try? jsonEncoder.encode(vnfo) else {
      throw DetectionError.jsonEncodingError
    }
    guard let s = String(data: d, encoding: .utf8) else {
      // Apple returned JSON Data which cannot be encoded to UFT8
      throw DetectionError.appleErrorMisc
    }
    return s
  }

  return "[" + jsons.joined(separator: ",\n") + "]"
}


