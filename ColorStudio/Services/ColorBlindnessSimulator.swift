import Foundation

enum ColorBlindnessType: String, CaseIterable {
    case protanopia = "Protanopia (Red-Blind)"
    case deuteranopia = "Deuteranopia (Green-Blind)"
    case tritanopia = "Tritanopia (Blue-Blind)"
    case protanomaly = "Protanomaly (Red-Weak)"
    case deuteranomaly = "Deuteranomaly (Green-Weak)"
    case tritanomaly = "Tritanomaly (Blue-Weak)"
    case achromatopsia = "Achromatopsia (Monochromacy)"
    case achromatomaly = "Achromatomaly (Blue Cone Monochromacy)"
}

class ColorBlindnessSimulator {
    static func simulate(color: ColorModel, type: ColorBlindnessType) -> ColorModel {
        let r = color.red
        let g = color.green
        let b = color.blue

        var transformedR: Double
        var transformedG: Double
        var transformedB: Double

        switch type {
        case .protanopia:
            transformedR = 0.567 * r + 0.433 * g + 0.0 * b
            transformedG = 0.558 * r + 0.442 * g + 0.0 * b
            transformedB = 0.0 * r + 0.242 * g + 0.758 * b

        case .deuteranopia:
            transformedR = 0.625 * r + 0.375 * g + 0.0 * b
            transformedG = 0.7 * r + 0.3 * g + 0.0 * b
            transformedB = 0.0 * r + 0.3 * g + 0.7 * b

        case .tritanopia:
            transformedR = 0.95 * r + 0.05 * g + 0.0 * b
            transformedG = 0.0 * r + 0.433 * g + 0.567 * b
            transformedB = 0.0 * r + 0.475 * g + 0.525 * b

        case .protanomaly:
            transformedR = 0.817 * r + 0.183 * g + 0.0 * b
            transformedG = 0.333 * r + 0.667 * g + 0.0 * b
            transformedB = 0.0 * r + 0.125 * g + 0.875 * b

        case .deuteranomaly:
            transformedR = 0.8 * r + 0.2 * g + 0.0 * b
            transformedG = 0.258 * r + 0.742 * g + 0.0 * b
            transformedB = 0.0 * r + 0.142 * g + 0.858 * b

        case .tritanomaly:
            transformedR = 0.967 * r + 0.033 * g + 0.0 * b
            transformedG = 0.0 * r + 0.733 * g + 0.267 * b
            transformedB = 0.0 * r + 0.183 * g + 0.817 * b

        case .achromatopsia:
            let gray = 0.299 * r + 0.587 * g + 0.114 * b
            transformedR = gray
            transformedG = gray
            transformedB = gray

        case .achromatomaly:
            let gray = 0.299 * r + 0.587 * g + 0.114 * b
            transformedR = 0.618 * r + 0.320 * g + 0.062 * b
            transformedG = 0.163 * r + 0.775 * g + 0.062 * b
            transformedB = 0.163 * r + 0.320 * g + 0.516 * b + 0.2 * gray
        }

        return ColorModel(
            name: color.name,
            red: min(max(transformedR, 0), 1),
            green: min(max(transformedG, 0), 1),
            blue: min(max(transformedB, 0), 1),
            alpha: color.alpha
        )
    }
}
