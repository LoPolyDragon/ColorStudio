import Foundation

struct ContrastResult {
    let ratio: Double
    let passesAA: Bool
    let passesAAA: Bool
    let passesAALarge: Bool
    let passesAAALarge: Bool

    var ratingDescription: String {
        if passesAAA {
            return "AAA - Enhanced (Excellent)"
        } else if passesAA {
            return "AA - Minimum (Good)"
        } else if passesAALarge {
            return "AA Large Text Only"
        } else {
            return "Fail (Poor)"
        }
    }
}

class AccessibilityChecker {
    static func calculateContrastRatio(foreground: ColorModel, background: ColorModel) -> ContrastResult {
        let l1 = relativeLuminance(of: foreground)
        let l2 = relativeLuminance(of: background)

        let lighter = max(l1, l2)
        let darker = min(l1, l2)

        let ratio = (lighter + 0.05) / (darker + 0.05)

        return ContrastResult(
            ratio: ratio,
            passesAA: ratio >= 4.5,
            passesAAA: ratio >= 7.0,
            passesAALarge: ratio >= 3.0,
            passesAAALarge: ratio >= 4.5
        )
    }

    private static func relativeLuminance(of color: ColorModel) -> Double {
        let r = gammaCorrect(color.red)
        let g = gammaCorrect(color.green)
        let b = gammaCorrect(color.blue)

        return 0.2126 * r + 0.7152 * g + 0.0722 * b
    }

    private static func gammaCorrect(_ value: Double) -> Double {
        if value <= 0.03928 {
            return value / 12.92
        } else {
            return pow((value + 0.055) / 1.055, 2.4)
        }
    }
}
