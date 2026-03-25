import AppKit
import SwiftUI

enum ExportFormat: String, CaseIterable {
    case ase = "Adobe Swatch Exchange (.ase)"
    case css = "CSS Variables (.css)"
    case swift = "Swift Color Extension (.swift)"
    case hex = "Hex List (.txt)"
    case png = "PNG Swatch (.png)"
}

class ExportManager {
    static func exportPalette(_ palette: Palette, format: ExportFormat) -> URL? {
        let fileName: String
        let data: Data?

        switch format {
        case .ase:
            fileName = "\(palette.name).ase"
            data = generateASE(palette: palette)
        case .css:
            fileName = "\(palette.name).css"
            data = generateCSS(palette: palette).data(using: .utf8)
        case .swift:
            fileName = "\(palette.name).swift"
            data = generateSwift(palette: palette).data(using: .utf8)
        case .hex:
            fileName = "\(palette.name).txt"
            data = generateHexList(palette: palette).data(using: .utf8)
        case .png:
            fileName = "\(palette.name).png"
            data = generatePNGSwatch(palette: palette)
        }

        guard let data = data else { return nil }

        let tempURL = FileManager.default.temporaryDirectory.appendingPathComponent(fileName)
        try? data.write(to: tempURL)

        return tempURL
    }

    private static func generateASE(palette: Palette) -> Data? {
        var data = Data()

        data.append("ASEF".data(using: .ascii)!)
        data.append(contentsOf: [0x00, 0x01, 0x00, 0x00])

        let blockCount = UInt32(palette.colors.count).bigEndian
        withUnsafeBytes(of: blockCount) { data.append(contentsOf: $0) }

        for color in palette.colors {
            data.append(contentsOf: [0x00, 0x01])

            let nameData = (color.name + "\0").data(using: .utf16BigEndian)!
            let nameLength = UInt32(nameData.count / 2 + 1).bigEndian
            withUnsafeBytes(of: nameLength) { data.append(contentsOf: $0) }
            data.append(nameData)

            data.append("RGB ".data(using: .ascii)!)

            let r = Float32(color.red).bitPattern.bigEndian
            let g = Float32(color.green).bitPattern.bigEndian
            let b = Float32(color.blue).bitPattern.bigEndian

            withUnsafeBytes(of: r) { data.append(contentsOf: $0) }
            withUnsafeBytes(of: g) { data.append(contentsOf: $0) }
            withUnsafeBytes(of: b) { data.append(contentsOf: $0) }

            data.append(contentsOf: [0x00, 0x02])
        }

        return data
    }

    private static func generateCSS(palette: Palette) -> String {
        var css = ":root {\n"

        for (index, color) in palette.colors.enumerated() {
            let varName = color.name
                .lowercased()
                .replacingOccurrences(of: " ", with: "-")
                .replacingOccurrences(of: "#", with: "")

            css += "  --color-\(varName.isEmpty ? "color-\(index + 1)" : varName): \(color.hexString);\n"
        }

        css += "}\n"
        return css
    }

    private static func generateSwift(palette: Palette) -> String {
        var swift = "import SwiftUI\n\n"
        swift += "extension Color {\n"

        for (index, color) in palette.colors.enumerated() {
            let varName = color.name
                .replacingOccurrences(of: " ", with: "")
                .replacingOccurrences(of: "#", with: "")
                .replacingOccurrences(of: "-", with: "")

            let name = varName.isEmpty ? "color\(index + 1)" : varName.prefix(1).lowercased() + varName.dropFirst()

            swift += "    static let \(name) = Color(red: \(color.red), green: \(color.green), blue: \(color.blue))\n"
        }

        swift += "}\n"
        return swift
    }

    private static func generateHexList(palette: Palette) -> String {
        return palette.colors.map { $0.hexString }.joined(separator: "\n")
    }

    private static func generatePNGSwatch(palette: Palette) -> Data? {
        let swatchSize: CGFloat = 100
        let width = swatchSize * CGFloat(palette.colors.count)
        let height = swatchSize

        let size = CGSize(width: width, height: height)

        let image = NSImage(size: size)
        image.lockFocus()

        for (index, color) in palette.colors.enumerated() {
            let rect = CGRect(x: CGFloat(index) * swatchSize, y: 0, width: swatchSize, height: swatchSize)
            color.nsColor.setFill()
            rect.fill()
        }

        image.unlockFocus()

        guard let tiffData = image.tiffRepresentation,
              let bitmapImage = NSBitmapImageRep(data: tiffData),
              let pngData = bitmapImage.representation(using: .png, properties: [:]) else {
            return nil
        }

        return pngData
    }
}
