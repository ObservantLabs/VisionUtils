//
//  File.swift
//  
//
//  Created by Alexis Gallagher on 2020-07-07.
//

import Foundation
import Vision

/**
 Encode a VNFaceObservation to encode all its properties
 */
extension VNFaceObservation : Encodable
{
  enum CodingKeys: String, CodingKey {
    // properties belonging to any VNObservation
    //    we ignore "uuid" and "timeRange" properties.
    /// confidence value
    case confidence

    // properties belonging to any VNDetectedObjectObservation
    /// bounding box of this observation
    case boundingBox

    // properties belonging to any VNObservation
    // landmarks detected
    case landmarks
  }
  public func encode(to encoder:Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    //    try container.encode(uuid,forKey:.uuid)
    try container.encode(confidence,forKey:.confidence)
    try container.encodeIfPresent(landmarks,forKey:.landmarks)
    try container.encode(boundingBox,forKey:.boundingBox)
  }
}

extension VNFaceLandmarks2D : Encodable {
  enum CodingKeys: String, CodingKey {
    case allPoints
    case faceContour
    case leftEye
    case rightEye
    case leftEyebrow
    case rightEyebrow
    case nose
    case noseCrest
    case medianLine
    case outerLips
    case innerLips
    case leftPupil
    case rightPupil
  }

  public func encode(to encoder: Encoder) throws {
    var values = encoder.container(keyedBy: CodingKeys.self)
    try values.encodeIfPresent(allPoints, forKey: .allPoints)
    try values.encodeIfPresent(faceContour, forKey: .faceContour)
    try values.encodeIfPresent(leftEye, forKey: .leftEye)
    try values.encodeIfPresent(rightEye, forKey: .rightEye)
    try values.encodeIfPresent(leftEyebrow, forKey: .leftEyebrow)
    try values.encodeIfPresent(rightEyebrow, forKey: .rightEyebrow)
    try values.encodeIfPresent(nose, forKey: .nose)
    try values.encodeIfPresent(noseCrest, forKey: .noseCrest)
    try values.encodeIfPresent(medianLine, forKey: .medianLine)
    try values.encodeIfPresent(outerLips, forKey: .outerLips)
    try values.encodeIfPresent(innerLips, forKey: .innerLips)
    try values.encodeIfPresent(leftPupil, forKey: .leftPupil)
    try values.encodeIfPresent(rightPupil, forKey: .rightPupil)
  }
}

extension VNFaceLandmarkRegion2D : Encodable
{
  enum CodingKeys: String, CodingKey {
    case normalizedPoints
  }
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(normalizedPoints,forKey:.normalizedPoints)
  }
}
