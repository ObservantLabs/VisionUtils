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
    case uuid
    case confidence
    // this property belonging to any VNDetectedObjectObsesrvation
    case boundingBox
    // we ignore further properties for now (landmarks, roll, yaw, faceCaptureQuality)
  }
  public func encode(to encoder:Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(uuid,forKey:.uuid)
    try container.encode(confidence,forKey:.confidence)
    try container.encode(boundingBox,forKey:.boundingBox)
  }
}
