import SwiftUI

struct HarmonyView: View {
    @Binding var baseColor: ColorModel
    @State private var selectedHarmony: HarmonyType = .complementary
    @State private var harmonyColors: [ColorModel] = []

    var body: some View {
        VStack(spacing: 20) {
            VStack(alignment: .leading, spacing: 8) {
                Text("Base Color")
                    .font(.headline)

                HStack {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(baseColor.color)
                        .frame(width: 60, height: 60)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                        )

                    Text(baseColor.hexString)
                        .font(.system(.body, design: .monospaced))
                }
            }

            Divider()

            Picker("Harmony Type", selection: $selectedHarmony) {
                ForEach(HarmonyType.allCases, id: \.self) { type in
                    Text(type.rawValue).tag(type)
                }
            }
            .pickerStyle(.menu)
            .onChange(of: selectedHarmony) { _, _ in
                generateHarmony()
            }
            .onChange(of: baseColor) { _, _ in
                generateHarmony()
            }

            if !harmonyColors.isEmpty {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Harmony Colors")
                        .font(.headline)

                    LazyVGrid(columns: [
                        GridItem(.adaptive(minimum: 60), spacing: 12)
                    ], spacing: 12) {
                        ForEach(harmonyColors) { color in
                            VStack(spacing: 4) {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color.color)
                                    .frame(width: 60, height: 60)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 8)
                                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                                    )

                                Text(color.hexString)
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .onAppear {
            generateHarmony()
        }
    }

    private func generateHarmony() {
        harmonyColors = HarmonyGenerator.generateHarmony(from: baseColor, type: selectedHarmony)
    }
}
