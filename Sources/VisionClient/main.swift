import Foundation
import ArgumentParser

import VisionUtils

extension FaceDataFormat : ExpressibleByArgument {}


struct FaceDetect: ParsableCommand {
  @Flag(help:"Print version of this tool and underlying Vision model")
  var version = false

  @Flag(help:"Print file names before running face detection")
  var verbose = false

  @Flag(help:"Quit running if a face detection generates an error")
  var quitOnError = false

  @Option(help:"createML or vision. Controls JSON format. In CreateML mode, will emit a JS dictionary if given multiple images")
  var outputFormat:FaceDataFormat = .createML

  @Option()
  var detectLandmarks:Bool = true

  @Argument(help:"images on which to run Vision face detection")
  var inputImages: [String] = []

  mutating func run() throws {
    if self.version {
      print(logVisionModelRevisions())
      Foundation.exit(EXIT_SUCCESS)
    }

    /// for CreateML, with multiple items, emit a JSON array containing the items.
    let shouldExportJSONArrayMode:Bool = (outputFormat == .createML) && (inputImages.count > 1) && (verbose == false)
    var firstItem:Bool = true
    if shouldExportJSONArrayMode { print("[") }

    // this is really not efficient, because we're rebuilding the Vision stack per image
    // better would be to do the loop in the func that did detection
    // or to create an object that owns the machinery and provides a stateless transform function,
    // and map a sequence through it.
    for path in inputImages {
      var u = URL(fileURLWithPath: path)
      u.standardize()

      do {
        let output:String = try faceDetect(image: u, outputFormat: self.outputFormat, withLandmarks: detectLandmarks)
        if self.verbose {
          print("Running face datect on: \(path)")
        }

        if shouldExportJSONArrayMode && !firstItem { print(",") }

        print(output)

        if firstItem { firstItem = false }

      }
      catch let e as DetectionError {
        // wow, this is allowed
        final class StandardErrorOutputStream: TextOutputStream {
            func write(_ string: String) {
                FileHandle.standardError.write(Data(string.utf8))
            }
        }
        var outputStream = StandardErrorOutputStream()

        print("Error running face detection on: \(path).", to: &outputStream)
        print("  this is the error: \(e)", to: &outputStream)
        if self.quitOnError {
          Foundation.exit(Foundation.EXIT_FAILURE)
        }
      }
    }

    if shouldExportJSONArrayMode {
      print("]")
    }
  }
}


FaceDetect.main()
