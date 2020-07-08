import Foundation
import ArgumentParser

import VisionUtils

struct FaceDetect: ParsableCommand {
  @Argument(help:"images on which to run Vision face detection")
  var inputImages: [String] = []

  @Flag(help:"Print file names before running face detection")
  var verbose = false

  mutating func run() throws {
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
      catch {
        // wow, this is allowed
        final class StandardErrorOutputStream: TextOutputStream {
            func write(_ string: String) {
                FileHandle.standardError.write(Data(string.utf8))
            }
        }
        var outputStream = StandardErrorOutputStream()

        print("Quitting, after an error running face detection on: \(path).", to: &outputStream)
        Foundation.exit(Foundation.EXIT_FAILURE)
      }
    }
  }
}


FaceDetect.main()
