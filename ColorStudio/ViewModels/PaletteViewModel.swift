import Foundation
import Combine

class PaletteViewModel: ObservableObject {
    @Published var palettes: [Palette] = []
    @Published var currentPalette: Palette?

    private let palettesKey = "ColorStudio.Palettes"

    init() {
        loadPalettes()
    }

    func createPalette(name: String, collectionId: UUID? = nil) {
        let palette = Palette(name: name, colors: [], collectionId: collectionId)
        palettes.append(palette)
        currentPalette = palette
        savePalettes()
    }

    func deletePalette(_ palette: Palette) {
        palettes.removeAll { $0.id == palette.id }
        if currentPalette?.id == palette.id {
            currentPalette = palettes.first
        }
        savePalettes()
    }

    func updatePalette(_ palette: Palette) {
        if let index = palettes.firstIndex(where: { $0.id == palette.id }) {
            palettes[index] = palette
            if currentPalette?.id == palette.id {
                currentPalette = palette
            }
            savePalettes()
        }
    }

    func addColorToPalette(_ color: ColorModel, palette: Palette) {
        var updatedPalette = palette
        updatedPalette.addColor(color)
        updatePalette(updatedPalette)
    }

    func removeColorFromPalette(at index: Int, palette: Palette) {
        var updatedPalette = palette
        updatedPalette.removeColor(at: index)
        updatePalette(updatedPalette)
    }

    func getPalettes(forCollection collectionId: UUID?) -> [Palette] {
        if let collectionId = collectionId {
            return palettes.filter { $0.collectionId == collectionId }
        } else {
            return palettes
        }
    }

    private func savePalettes() {
        if let encoded = try? JSONEncoder().encode(palettes) {
            UserDefaults.standard.set(encoded, forKey: palettesKey)
        }
    }

    private func loadPalettes() {
        if let data = UserDefaults.standard.data(forKey: palettesKey),
           let decoded = try? JSONDecoder().decode([Palette].self, from: data) {
            palettes = decoded
            currentPalette = palettes.first
        } else {
            let defaultPalette = Palette(name: "My First Palette", colors: [
                ColorModel(name: "#FF6B6B", red: 1.0, green: 0.42, blue: 0.42),
                ColorModel(name: "#4ECDC4", red: 0.31, green: 0.80, blue: 0.77),
                ColorModel(name: "#45B7D1", red: 0.27, green: 0.72, blue: 0.82),
                ColorModel(name: "#FFA07A", red: 1.0, green: 0.63, blue: 0.48),
                ColorModel(name: "#98D8C8", red: 0.60, green: 0.85, blue: 0.78)
            ])
            palettes = [defaultPalette]
            currentPalette = defaultPalette
            savePalettes()
        }
    }
}
