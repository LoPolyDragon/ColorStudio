import SwiftUI

struct PaletteEditorView: View {
    @ObservedObject var paletteViewModel: PaletteViewModel
    @Binding var palette: Palette
    @State private var selectedColor = ColorModel(name: "#3498DB", red: 0.20, green: 0.60, blue: 0.86)
    @State private var selectedTab = "picker"
    @State private var extractedColors: [ColorModel] = []
    @StateObject private var colorPicker = MenuBarColorPicker()
    @State private var showingExport = false
    @State private var showingColorBlindness = false

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                TextField("Palette Name", text: $palette.name)
                    .textFieldStyle(.roundedBorder)
                    .font(.title2)
                    .onSubmit {
                        paletteViewModel.updatePalette(palette)
                    }

                Spacer()

                Button(action: {
                    colorPicker.startPicking { color in
                        paletteViewModel.addColorToPalette(color, palette: palette)
                        palette = paletteViewModel.currentPalette ?? palette
                    }
                }) {
                    Label("Pick Screen Color", systemImage: "eyedropper")
                }
                .buttonStyle(.bordered)

                Button(action: { showingColorBlindness = true }) {
                    Label("Simulate", systemImage: "eye")
                }
                .buttonStyle(.bordered)
                .disabled(palette.colors.isEmpty)

                Button(action: { showingExport = true }) {
                    Label("Export", systemImage: "square.and.arrow.up")
                }
                .buttonStyle(.borderedProminent)
                .disabled(palette.colors.isEmpty)
            }
            .padding()

            Divider()

            HSplitView {
                VStack(spacing: 0) {
                    Picker("", selection: $selectedTab) {
                        Text("Color Picker").tag("picker")
                        Text("From Image").tag("image")
                        Text("Harmony").tag("harmony")
                    }
                    .pickerStyle(.segmented)
                    .padding()

                    Divider()

                    switch selectedTab {
                    case "picker":
                        ColorPickerView(selectedColor: $selectedColor)

                    case "image":
                        ImageDropView(extractedColors: $extractedColors)

                    case "harmony":
                        HarmonyView(baseColor: $selectedColor)

                    default:
                        EmptyView()
                    }

                    Divider()

                    HStack {
                        Spacer()

                        Button("Add to Palette") {
                            if selectedTab == "image" && !extractedColors.isEmpty {
                                for color in extractedColors {
                                    paletteViewModel.addColorToPalette(color, palette: palette)
                                }
                                palette = paletteViewModel.currentPalette ?? palette
                                extractedColors = []
                            } else if selectedTab == "harmony" {
                                let harmonyColors = HarmonyGenerator.generateHarmony(from: selectedColor, type: .complementary)
                                for color in harmonyColors {
                                    paletteViewModel.addColorToPalette(color, palette: palette)
                                }
                                palette = paletteViewModel.currentPalette ?? palette
                            } else {
                                paletteViewModel.addColorToPalette(selectedColor, palette: palette)
                                palette = paletteViewModel.currentPalette ?? palette
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .padding()
                    }
                }
                .frame(minWidth: 400)

                VStack(spacing: 0) {
                    HStack {
                        Text("Palette Colors")
                            .font(.headline)

                        Spacer()

                        Text("\(palette.colors.count) colors")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    .padding()

                    Divider()

                    if palette.colors.isEmpty {
                        VStack(spacing: 12) {
                            Image(systemName: "paintpalette")
                                .font(.system(size: 48))
                                .foregroundColor(.secondary)

                            Text("No colors in palette")
                                .font(.headline)
                                .foregroundColor(.secondary)

                            Text("Add colors using the picker, extract from images, or generate harmonies")
                                .font(.caption)
                                .foregroundColor(.secondary)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    } else {
                        ScrollView {
                            LazyVGrid(columns: [
                                GridItem(.adaptive(minimum: 80), spacing: 12)
                            ], spacing: 12) {
                                ForEach(Array(palette.colors.enumerated()), id: \.element.id) { index, color in
                                    ColorCard(color: color) {
                                        paletteViewModel.removeColorFromPalette(at: index, palette: palette)
                                        palette = paletteViewModel.currentPalette ?? palette
                                    }
                                }
                            }
                            .padding()
                        }
                    }
                }
                .frame(minWidth: 300)
            }
        }
        .sheet(isPresented: $showingExport) {
            ExportView(palette: palette)
        }
        .sheet(isPresented: $showingColorBlindness) {
            ColorBlindnessView(palette: palette)
        }
    }
}

struct ColorCard: View {
    let color: ColorModel
    let onDelete: () -> Void

    var body: some View {
        VStack(spacing: 8) {
            RoundedRectangle(cornerRadius: 8)
                .fill(color.color)
                .frame(height: 80)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                )
                .overlay(
                    Button(action: onDelete) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.white)
                            .background(Circle().fill(Color.black.opacity(0.5)))
                    }
                    .buttonStyle(.plain)
                    .padding(4),
                    alignment: .topTrailing
                )

            VStack(spacing: 2) {
                Text(color.hexString)
                    .font(.system(.caption, design: .monospaced))
                    .fontWeight(.medium)

                let rgb = "R:\(Int(color.red * 255)) G:\(Int(color.green * 255)) B:\(Int(color.blue * 255))"
                Text(rgb)
                    .font(.system(.caption2, design: .monospaced))
                    .foregroundColor(.secondary)
            }
        }
    }
}
