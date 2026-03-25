import SwiftUI

struct ColorBlindnessView: View {
    let palette: Palette
    @State private var selectedType: ColorBlindnessType = .protanopia
    @State private var simulatedColors: [ColorModel] = []

    var body: some View {
        VStack(spacing: 20) {
            Text("Color Blindness Simulator")
                .font(.title2)
                .fontWeight(.semibold)

            Picker("Color Blindness Type", selection: $selectedType) {
                ForEach(ColorBlindnessType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedType) { _, _ in
                simulateColors()
            }

            Divider()

            HStack(spacing: 40) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Original")
                        .font(.headline)

                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 50), spacing: 8)
                    ], spacing: 8) {
                        ForEach(palette.colors) { color in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text("Simulated")
                        .font(.headline)

                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 50), spacing: 8)
                    ], spacing: 8) {
                        ForEach(simulatedColors) { color in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color.color)
                                .frame(width: 50, height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                )
                        }
                    }
                }
            }

            Text("This simulation shows how people with \(selectedType.rawValue.lowercased()) perceive your palette.")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding()
        .frame(width: 500)
        .onAppear {
            simulateColors()
        }
        .onChange(of: palette) { _, _ in
            simulateColors()
        }
    }

    private func simulateColors() {
        simulatedColors = palette.colors.map { color in
            ColorBlindnessSimulator.simulate(color: color, type: selectedType)
        }
    }
}
