import SwiftUI

struct ExportView: View {
    let palette: Palette
    @State private var selectedFormat: ExportFormat = .css
    @State private var showingSavePanel = false

    var body: some View {
        VStack(spacing: 20) {
            Text("Export Palette")
                .font(.title2)
                .fontWeight(.semibold)

            VStack(alignment: .leading, spacing: 8) {
                Text("Palette: \(palette.name)")
                    .font(.headline)

                Text("\(palette.colors.count) colors")
                    .font(.subheadline)
                    .foregroundColor(.secondary)

                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(palette.colors) { color in
                            RoundedRectangle(cornerRadius: 6)
                                .fill(color.color)
                                .frame(width: 40, height: 40)
                        }
                    }
                }
            }

            Divider()

            VStack(alignment: .leading, spacing: 12) {
                Text("Export Format")
                    .font(.headline)

                Picker("Format", selection: $selectedFormat) {
                    ForEach(ExportFormat.allCases, id: \.self) { format in
                        Text(format.rawValue).tag(format)
                    }
                }
                .pickerStyle(.radioGroup)
            }

            Spacer()

            Button("Export") {
                exportPalette()
            }
            .buttonStyle(.borderedProminent)
        }
        .padding()
        .frame(width: 400)
    }

    private func exportPalette() {
        guard let tempURL = ExportManager.exportPalette(palette, format: selectedFormat) else {
            return
        }

        let savePanel = NSSavePanel()
        savePanel.nameFieldStringValue = tempURL.lastPathComponent
        savePanel.allowedContentTypes = [.init(filenameExtension: tempURL.pathExtension)].compactMap { $0 }

        savePanel.begin { response in
            if response == .OK, let url = savePanel.url {
                try? FileManager.default.copyItem(at: tempURL, to: url)
            }
            try? FileManager.default.removeItem(at: tempURL)
        }
    }
}
