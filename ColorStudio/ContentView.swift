import SwiftUI

struct ContentView: View {
    @StateObject private var paletteViewModel = PaletteViewModel()
    @StateObject private var collectionViewModel = CollectionViewModel()
    @State private var selectedCollection: Collection?
    @State private var selectedPalette: Palette?

    var body: some View {
        NavigationSplitView {
            CollectionSidebar(
                collectionViewModel: collectionViewModel,
                selectedCollection: $selectedCollection
            )
        } content: {
            PaletteListView(
                paletteViewModel: paletteViewModel,
                selectedPalette: $selectedPalette,
                collectionId: selectedCollection?.name == "All Palettes" ? nil : selectedCollection?.id
            )
            .frame(minWidth: 250)
        } detail: {
            if let palette = selectedPalette {
                PaletteEditorView(
                    paletteViewModel: paletteViewModel,
                    palette: Binding(
                        get: { palette },
                        set: { newValue in
                            paletteViewModel.updatePalette(newValue)
                            selectedPalette = newValue
                        }
                    )
                )
            } else {
                VStack(spacing: 20) {
                    Image(systemName: "paintpalette")
                        .font(.system(size: 64))
                        .foregroundColor(.secondary)

                    Text("Select a palette to get started")
                        .font(.title2)
                        .foregroundColor(.secondary)

                    Text("Or create a new palette using the + button")
                        .font(.body)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
        }
        .navigationSplitViewStyle(.balanced)
        .onAppear {
            selectedCollection = collectionViewModel.collections.first
            selectedPalette = paletteViewModel.palettes.first
        }
    }
}
