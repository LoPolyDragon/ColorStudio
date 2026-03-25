import SwiftUI

struct ColorModel: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var red: Double
    var green: Double
    var blue: Double
    var alpha: Double

    init(id: UUID = UUID(), name: String = "Untitled", red: Double, green: Double, blue: Double, alpha: Double = 1.0) {
        self.id = id
        self.name = name
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    init(nsColor: NSColor, name: String = "Untitled") {
        let rgb = nsColor.usingColorSpace(.sRGB) ?? nsColor
        self.id = UUID()
        self.name = name
        self.red = Double(rgb.redComponent)
        self.green = Double(rgb.greenComponent)
        self.blue = Double(rgb.blueComponent)
        self.alpha = Double(rgb.alphaComponent)
    }

    var nsColor: NSColor {
        NSColor(red: red, green: green, blue: blue, alpha: alpha)
    }

    var color: Color {
        Color(nsColor: nsColor)
    }

    var hexString: String {
        let r = Int(red * 255)
        let g = Int(green * 255)
        let b = Int(blue * 255)
        return String(format: "#%02X%02X%02X", r, g, b)
    }

    init(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        self.id = UUID()
        self.name = "Untitled"
        self.red = Double((rgb & 0xFF0000) >> 16) / 255.0
        self.green = Double((rgb & 0x00FF00) >> 8) / 255.0
        self.blue = Double(rgb & 0x0000FF) / 255.0
        self.alpha = 1.0
    }

    var hsb: (hue: Double, saturation: Double, brightness: Double) {
        let nsColor = self.nsColor
        var hue: CGFloat = 0
        var saturation: CGFloat = 0
        var brightness: CGFloat = 0
        var alpha: CGFloat = 0
        nsColor.getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
        return (Double(hue), Double(saturation), Double(brightness))
    }

    init(hue: Double, saturation: Double, brightness: Double, alpha: Double = 1.0) {
        let nsColor = NSColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
        let rgb = nsColor.usingColorSpace(.sRGB) ?? nsColor
        self.id = UUID()
        self.name = "Untitled"
        self.red = Double(rgb.redComponent)
        self.green = Double(rgb.greenComponent)
        self.blue = Double(rgb.blueComponent)
        self.alpha = alpha
    }

    var cmyk: (cyan: Double, magenta: Double, yellow: Double, black: Double) {
        let k = 1 - max(red, green, blue)
        let c = k >= 1 ? 0 : (1 - red - k) / (1 - k)
        let m = k >= 1 ? 0 : (1 - green - k) / (1 - k)
        let y = k >= 1 ? 0 : (1 - blue - k) / (1 - k)
        return (c, m, y, k)
    }

    var lab: (l: Double, a: Double, b: Double) {
        func pivotRGB(_ n: Double) -> Double {
            return n > 0.04045 ? pow((n + 0.055) / 1.055, 2.4) : n / 12.92
        }

        var r = pivotRGB(red)
        var g = pivotRGB(green)
        var b = pivotRGB(blue)

        r *= 100
        g *= 100
        b *= 100

        var x = r * 0.4124 + g * 0.3576 + b * 0.1805
        var y = r * 0.2126 + g * 0.7152 + b * 0.0722
        var z = r * 0.0193 + g * 0.1192 + b * 0.9505

        x /= 95.047
        y /= 100.0
        z /= 108.883

        func pivotXYZ(_ n: Double) -> Double {
            return n > 0.008856 ? pow(n, 1.0/3.0) : (7.787 * n) + (16.0 / 116.0)
        }

        x = pivotXYZ(x)
        y = pivotXYZ(y)
        z = pivotXYZ(z)

        let l = max(0, 116 * y - 16)
        let a = 500 * (x - y)
        let bVal = 200 * (y - z)

        return (l, a, bVal)
    }
}
