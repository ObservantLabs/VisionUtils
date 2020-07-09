import Foundation
import ArgumentParser

import VisionUtils

struct FaceDetect: ParsableCommand {
  @Argument(help:"images on which to run Vision face detection")
  var inputImages: [String] = []

  @Flag(help:"Print version of this tool and underlying Vision model")
  var version = false

  @Flag(help:"Print file names before running face detection")
  var verbose = false

  @Flag(help:"Quit running if a face detection generates an error")
  var quitOnError = false

  mutating func run() throws {
    if self.version {
      print(logVisionModelRevisions())
      Foundation.exit(EXIT_SUCCESS)
    }
    
    for path in inputImages {
      var u = URL(fileURLWithPath: path)
      u.standardize()

      do {
        let output:String = try faceDetect(image: u)
        if self.verbose {
          print("Running face datect on: \(path)")
        }
        print(output)
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
  }
}


FaceDetect.main()
