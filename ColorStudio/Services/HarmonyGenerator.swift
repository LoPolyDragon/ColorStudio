import Foundation

enum HarmonyType: String, CaseIterable {
    case complementary = "Complementary"
    case triadic = "Triadic"
    case analogous = "Analogous"
    case splitComplementary = "Split Complementary"
    case tetradic = "Tetradic"
}

class HarmonyGenerator {
    static func generateHarmony(from color: ColorModel, type: HarmonyType) -> [ColorModel] {
        let hsb = color.hsb
        let hue = hsb.hue
        let saturation = hsb.saturation
        let brightness = hsb.brightness
        let alpha = color.alpha

        var colors: [ColorModel] = [color]

        switch type {
        case .complementary:
            let complementaryHue = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
            colors.append(ColorModel(
                hue: complementaryHue,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))

        case .triadic:
            let hue2 = (hue + 1.0/3.0).truncatingRemainder(dividingBy: 1.0)
            let hue3 = (hue + 2.0/3.0).truncatingRemainder(dividingBy: 1.0)

            colors.append(ColorModel(
                hue: hue2,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
            colors.append(ColorModel(
                hue: hue3,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))

        case .analogous:
            let hue1 = (hue - 30.0/360.0 + 1.0).truncatingRemainder(dividingBy: 1.0)
            let hue2 = (hue + 30.0/360.0).truncatingRemainder(dividingBy: 1.0)

            colors.append(ColorModel(
                hue: hue1,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
            colors.append(ColorModel(
                hue: hue2,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))

        case .splitComplementary:
            let complementary = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
            let split1 = (complementary - 30.0/360.0 + 1.0).truncatingRemainder(dividingBy: 1.0)
            let split2 = (complementary + 30.0/360.0).truncatingRemainder(dividingBy: 1.0)

            colors.append(ColorModel(
                hue: split1,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
            colors.append(ColorModel(
                hue: split2,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))

        case .tetradic:
            let hue2 = (hue + 0.25).truncatingRemainder(dividingBy: 1.0)
            let hue3 = (hue + 0.5).truncatingRemainder(dividingBy: 1.0)
            let hue4 = (hue + 0.75).truncatingRemainder(dividingBy: 1.0)

            colors.append(ColorModel(
                hue: hue2,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
            colors.append(ColorModel(
                hue: hue3,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
            colors.append(ColorModel(
                hue: hue4,
                saturation: saturation,
                brightness: brightness,
                alpha: alpha
            ))
        }

        for i in 0..<colors.count {
            colors[i].name = colors[i].hexString
        }

        return colors
    }
}
