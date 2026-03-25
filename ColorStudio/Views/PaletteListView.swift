import SwiftUI

struct PaletteListView: View {
    @ObservedObject var paletteViewModel: PaletteViewModel
    @Binding var selectedPalette: Palette?
    let collectionId: UUID?
    @State private var showingNewPalette = false
    @State private var newPaletteName = ""

    var palettes: [Palette] {
        paletteViewModel.getPalettes(forCollection: collectionId)
    }

    var body: some View {
        VStack(spacing: 0) {
            HStack {
                Text("Palettes")
                    .font(.headline)
                    .padding(.horizontal)

                Spacer()

                Button(action: { showingNewPalette = true }) {
                    Image(systemName: "plus.circle.fill")
                }
                .buttonStyle(.borderless)
                .padding(.trailing)
            }
            .padding(.vertical, 8)

            Divider()

            if palettes.isEmpty {
                VStack(spacing: 12) {
                    Image(systemName: "rectangle.3.group")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)

                    Text("No palettes yet")
                        .font(.headline)
                        .foregroundColor(.secondary)

                    Button("Create Palette") {
                        showingNewPalette = true
                    }
                    .buttonStyle(.borderedProminent)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                List(palettes, selection: $selectedPalette) { palette in
                    PaletteRow(palette: palette)
                        .tag(palette as Palette?)
                        .contextMenu {
                            Button("Delete") {
                                paletteViewModel.deletePalette(palette)
                            }
                        }
                }
            }
        }
        .sheet(isPresented: $showingNewPalette) {
            VStack(spacing: 16) {
                Text("New Palette")
                    .font(.headline)

                TextField("Palette Name", text: $newPaletteName)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        showingNewPalette = false
                        newPaletteName = ""
                    }

                    Button("Create") {
                        if !newPaletteName.isEmpty {
                            paletteViewModel.createPalette(name: newPaletteName, collectionId: collectionId)
                            showingNewPalette = false
                            newPaletteName = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newPaletteName.isEmpty)
                }
            }
            .padding()
            .frame(width: 300)
        }
    }
}

struct PaletteRow: View {
    let palette: Palette

    var body: some View {
        HStack {
            HStack(spacing: 4) {
                ForEach(palette.colors.prefix(5)) { color in
                    RoundedRectangle(cornerRadius: 3)
                        .fill(color.color)
                        .frame(width: 20, height: 20)
                }
            }

            VStack(alignment: .leading) {
                Text(palette.name)
                    .font(.headline)

                Text("\(palette.colors.count) colors")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }

            Spacer()
        }
        .padding(.vertical, 4)
    }
}
