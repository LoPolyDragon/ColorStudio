import SwiftUI

struct AccessibilityView: View {
    @State private var foregroundColor = ColorModel(name: "#000000", red: 0, green: 0, blue: 0)
    @State private var backgroundColor = ColorModel(name: "#FFFFFF", red: 1, green: 1, blue: 1)
    @State private var contrastResult: ContrastResult?

    var body: some View {
        VStack(spacing: 20) {
            Text("WCAG Contrast Checker")
                .font(.title2)
                .fontWeight(.semibold)

            HStack(spacing: 40) {
                VStack(spacing: 8) {
                    Text("Foreground")
                        .font(.headline)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(foregroundColor.color)
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Text(foregroundColor.hexString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }

                VStack(spacing: 8) {
                    Text("Background")
                        .font(.headline)

                    RoundedRectangle(cornerRadius: 8)
                        .fill(backgroundColor.color)
                        .frame(width: 80, height: 80)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Text(backgroundColor.hexString)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }

            Button("Swap Colors") {
                swap(&foregroundColor, &backgroundColor)
                checkContrast()
            }

            Divider()

            if let result = contrastResult {
                VStack(spacing: 16) {
                    Text("Contrast Ratio")
                        .font(.headline)

                    Text("\(String(format: "%.2f", result.ratio)):1")
                        .font(.system(size: 36, weight: .bold, design: .rounded))

                    Text(result.ratingDescription)
                        .font(.title3)
                        .foregroundColor(result.passesAA ? .green : .red)

                    VStack(alignment: .leading, spacing: 8) {
                        HStack {
                            Image(systemName: result.passesAA ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.passesAA ? .green : .red)
                            Text("WCAG AA Normal Text (4.5:1)")
                        }

                        HStack {
                            Image(systemName: result.passesAAA ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.passesAAA ? .green : .red)
                            Text("WCAG AAA Normal Text (7.0:1)")
                        }

                        HStack {
                            Image(systemName: result.passesAALarge ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.passesAALarge ? .green : .red)
                            Text("WCAG AA Large Text (3.0:1)")
                        }

                        HStack {
                            Image(systemName: result.passesAAALarge ? "checkmark.circle.fill" : "xmark.circle.fill")
                                .foregroundColor(result.passesAAALarge ? .green : .red)
                            Text("WCAG AAA Large Text (4.5:1)")
                        }
                    }
                    .font(.callout)

                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(backgroundColor.color)

                        Text("Sample Text Preview")
                            .font(.title3)
                            .foregroundColor(foregroundColor.color)
                            .padding()
                    }
                    .frame(height: 80)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                    )
                }
            }
        }
        .padding()
        .onAppear {
            checkContrast()
        }
    }

    private func checkContrast() {
        contrastResult = AccessibilityChecker.calculateContrastRatio(
            foreground: foregroundColor,
            background: backgroundColor
        )
    }
}
