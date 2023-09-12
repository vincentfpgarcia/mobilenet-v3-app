/*
See the License.txt file for this sample’s licensing information.
*/

import AVFoundation
import SwiftUI
import os.log
import MobileNetV3Package

final class Engine: ObservableObject {
    let camera = Camera()

    @Published var viewfinderImage: Image?
    @Published var cgImage: CGImage?
    @Published var debugImage: Image?
    @Published var label: String?
    @Published var probability: Double?
    @Published var fps: Int?

    init() {
        Task {
            await handleCameraPreviews()
        }
        Task {
            await processPicture()
        }
    }

    func handleCameraPreviews() async {
//        let imageStream = camera.previewStream
//            .map { $0.image }
//
//        for await image in imageStream {
//            Task { @MainActor in
//                viewfinderImage = image
//            }
//        }
        for await image in camera.previewStream {
            Task { @MainActor in
                cgImage = image.cgImage
                viewfinderImage = image.image
            }
        }
    }


    func processPicture() async {

        let model = MobileNetV3Package()!

        while true {

            if let image = cgImage {

                print("Image size: \(image.width) x \(image.height)")

//                // Crop and resize the image
//                let w = image.width
//                let h = image.height
//                let l = min(w, h)
//                let x = (w - l) / 2
//                let y = (h - l) / 2
//                let imageCropped = image.cropping(to: CGRect(x: x, y: y, width: l, height: l))!
//                let imageResized = imageCropped.resize(size: CGSize(width: 224, height: 224))!

                // Resize the image
                let imageResized = image.resize(size: CGSize(width: 224, height: 224))!

                // Perform the inference
                let start = DispatchTime.now()
                let (label, probability) = model.predict(input: UIImage(cgImage: imageResized))
                let end = DispatchTime.now()

                // Compute the average inference time
                let durationInMs = Double(end.uptimeNanoseconds - start.uptimeNanoseconds) / 1000000.0
                let fps = Int(1000.0 / durationInMs)

                // Update the UI
                Task { @MainActor in
                    self.debugImage = Image(decorative: imageResized, scale: 1, orientation: .up)
                    self.label = label
                    self.probability = probability
                    self.fps = fps
                }


//                try! await Task.sleep(nanoseconds: 100_000_000)


            }

//            sleep(1)
        }
    }

}

fileprivate extension CIImage {
    var image: Image? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return Image(decorative: cgImage, scale: 1, orientation: .up)
    }

    var cgImage: CGImage? {
        let ciContext = CIContext()
        guard let cgImage = ciContext.createCGImage(self, from: self.extent) else { return nil }
        return cgImage
    }
}

fileprivate extension CGImage {
    func resize(size:CGSize) -> CGImage? {
        let width: Int = Int(size.width)
        let height: Int = Int(size.height)

        let bytesPerPixel = self.bitsPerPixel / self.bitsPerComponent
        let destBytesPerRow = width * bytesPerPixel

        guard let colorSpace = self.colorSpace else { return nil }
        guard let context = CGContext(data: nil, width: width, height: height, bitsPerComponent: self.bitsPerComponent, bytesPerRow: destBytesPerRow, space: colorSpace, bitmapInfo: self.alphaInfo.rawValue) else { return nil }

        context.interpolationQuality = .high
        context.draw(self, in: CGRect(x: 0, y: 0, width: width, height: height))

        return context.makeImage()
    }
}
