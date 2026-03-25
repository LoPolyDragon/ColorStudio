import AppKit
import CoreImage

class ImageColorExtractor {
    static func extractDominantColors(from image: NSImage, count: Int = 5) -> [ColorModel] {
        guard let cgImage = image.cgImage(forProposedRect: nil, context: nil, hints: nil) else {
            return []
        }

        let ciImage = CIImage(cgImage: cgImage)
        let extents = ciImage.extent

        let width = Int(extents.width)
        let height = Int(extents.height)

        let context = CIContext()
        guard let bitmap = context.createCGImage(ciImage, from: extents) else {
            return []
        }

        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let bytesPerPixel = 4
        let bytesPerRow = bytesPerPixel * width
        let bitsPerComponent = 8

        var pixelData = [UInt8](repeating: 0, count: width * height * bytesPerPixel)

        guard let bitmapContext = CGContext(
            data: &pixelData,
            width: width,
            height: height,
            bitsPerComponent: bitsPerComponent,
            bytesPerRow: bytesPerRow,
            space: colorSpace,
            bitmapInfo: CGImageAlphaInfo.premultipliedLast.rawValue
        ) else {
            return []
        }

        bitmapContext.draw(bitmap, in: CGRect(x: 0, y: 0, width: width, height: height))

        var colorCounts: [String: Int] = [:]
        let sampleRate = max(1, width * height / 10000)

        for y in stride(from: 0, to: height, by: sampleRate) {
            for x in stride(from: 0, to: width, by: sampleRate) {
                let pixelIndex = (y * width + x) * bytesPerPixel

                let r = pixelData[pixelIndex]
                let g = pixelData[pixelIndex + 1]
                let b = pixelData[pixelIndex + 2]

                let quantized = quantizeColor(r: r, g: g, b: b, levels: 8)
                let key = "\(quantized.r)-\(quantized.g)-\(quantized.b)"
                colorCounts[key, default: 0] += 1
            }
        }

        let sortedColors = colorCounts.sorted { $0.value > $1.value }
        let dominantColors = sortedColors.prefix(count).compactMap { entry -> ColorModel? in
            let components = entry.key.split(separator: "-").compactMap { Int($0) }
            guard components.count == 3 else { return nil }

            return ColorModel(
                name: "Color",
                red: Double(components[0]) / 255.0,
                green: Double(components[1]) / 255.0,
                blue: Double(components[2]) / 255.0
            )
        }

        return dominantColors
    }

    private static func quantizeColor(r: UInt8, g: UInt8, b: UInt8, levels: Int) -> (r: UInt8, g: UInt8, b: UInt8) {
        let step = 256 / levels
        return (
            r: UInt8((Int(r) / step) * step),
            g: UInt8((Int(g) / step) * step),
            b: UInt8((Int(b) / step) * step)
        )
    }
}
