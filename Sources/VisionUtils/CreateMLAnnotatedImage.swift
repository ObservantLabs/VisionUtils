//
//  File.swift
//  
//
//  Created by Alexis Gallagher on 2020-07-08.
//

import Foundation
import Vision
import CoreGraphics

struct AnnotatedImage {
  /// filename
  var image:String

  var annotations:Array<Annotation>
}

struct Annotation {
  var label:String
  var coordinates:Coordinates
}

struct Coordinates
{
  /// centerX with a top-left origin, in pixels
  var x:Double
  /// centerY with a top-left origin, in pixels
  var y:Double
  /// width in pixels
  var width:Double
  /// height in pixels
  var height:Double
}

enum AnnotationError : Error {
  case errorGetDimensions
}

/// Creates an AnnotatedImage, a struct that mirrors the CreateML JSON format or an annotated image
///
/// One thing this handles is unit conversion. VNFaceObservation describes bounding boxes using the images corner coordinates,
/// normalized from 0...1, with a bottom-left origin. CreateML on the other hand describes bounding boxes using the box centers,
/// with pixel coordinaets, and a top-left origin.
///
/// - Parameters:
///   - image: URL to the image, which must be readable on disk to look up its pixel dimensions
///   - observations: a `Array<VNFaceObservation>` containing at leasst face detection results
/// - Throws: a `AnnotationError` if it cannot read the file and find its pixel dimensions
/// - Returns: an AnnotatedImage
func CreateAnnotatedImage(image:URL,observations:[VNFaceObservation]) throws -> AnnotatedImage
{
  /// (surely there's a more elegant cross-platform way to grab only image dimensions in pixels ?)
  guard let (imageWidth,imageHeight) = getImageDimensions(image: image) else {
    throw AnnotationError.errorGetDimensions
  }

  let anns:[Annotation] = observations.map {
    (fo:VNFaceObservation) -> Annotation in

    // get face bounding box (bottom-left origin, cooordinates normalized to 0...1)
    let bb = fo.boundingBox

    let boxWidth = Double(bb.width) * Double(imageWidth)
    let boxHeight = Double(bb.height) * Double(imageHeight)

    let boxLeftBLOrigin = Double(imageWidth) * Double(bb.minX)
    let boxRightBLOrigin = Double(imageWidth) * Double(bb.maxX)
    let boxCenterXBLOrigin = (boxLeftBLOrigin + boxRightBLOrigin) / 2.0

    let boxBottomBLOrigin = Double(imageHeight) * Double(bb.minY)
    let boxTopBLOrigin = Double(imageHeight) * Double(bb.maxY)
    let boxCenterYBLOrigin = (boxBottomBLOrigin + boxTopBLOrigin) / 2.0

    let boxCenterXLTLOrigin = boxCenterXBLOrigin
    let boxCenterYTLOrigin = boxHeight - boxCenterYBLOrigin

    let c = Coordinates(x: boxCenterXLTLOrigin, y: boxCenterYTLOrigin,
                        width: boxWidth, height: boxHeight)

    let ann = Annotation(label: "face", coordinates: c)
    return ann
  }

  let imageName = image.lastPathComponent

  return AnnotatedImage(image: imageName, annotations: anns)
}

fileprivate func getImageDimensions(image:URL) -> (UInt,UInt)? {
  /// Oddly I can find no more succinct, cross-platform way to grab only image dimensions in pixels.
  guard
    let imageSrc = CGImageSourceCreateWithURL(image as NSURL, nil),
    let properties = CGImageSourceCopyPropertiesAtIndex(imageSrc, 0,nil) as? [CFString:Any],
    // property is a CFNumber, toll-free bridged to NSNumber,
    // which we assume is a UInt since we're counting pixels
    let widthPx = properties[kCGImagePropertyPixelWidth] as? UInt,
    let heightPx = properties[kCGImagePropertyPixelHeight] as? UInt
  else {
    return nil
  }
  return (widthPx,heightPx)
}

