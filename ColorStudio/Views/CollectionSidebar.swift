import SwiftUI

struct CollectionSidebar: View {
    @ObservedObject var collectionViewModel: CollectionViewModel
    @Binding var selectedCollection: Collection?
    @State private var showingAddCollection = false
    @State private var newCollectionName = ""

    var body: some View {
        VStack(spacing: 0) {
            List(selection: $selectedCollection) {
                ForEach(collectionViewModel.collections) { collection in
                    HStack {
                        Image(systemName: "folder.fill")
                            .foregroundColor(.accentColor)
                        Text(collection.name)
                    }
                    .tag(collection as Collection?)
                }
            }

            Divider()

            HStack {
                Button(action: { showingAddCollection = true }) {
                    Image(systemName: "plus")
                }
                .buttonStyle(.borderless)

                Button(action: deleteSelectedCollection) {
                    Image(systemName: "minus")
                }
                .buttonStyle(.borderless)
                .disabled(selectedCollection == nil || selectedCollection?.name == "All Palettes")

                Spacer()
            }
            .padding(8)
        }
        .frame(minWidth: 200)
        .sheet(isPresented: $showingAddCollection) {
            VStack(spacing: 16) {
                Text("New Collection")
                    .font(.headline)

                TextField("Collection Name", text: $newCollectionName)
                    .textFieldStyle(.roundedBorder)

                HStack {
                    Button("Cancel") {
                        showingAddCollection = false
                        newCollectionName = ""
                    }

                    Button("Create") {
                        if !newCollectionName.isEmpty {
                            collectionViewModel.addCollection(name: newCollectionName)
                            showingAddCollection = false
                            newCollectionName = ""
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .disabled(newCollectionName.isEmpty)
                }
            }
            .padding()
            .frame(width: 300)
        }
    }

    private func deleteSelectedCollection() {
        guard let collection = selectedCollection,
              collection.name != "All Palettes" else { return }
        collectionViewModel.deleteCollection(collection)
        selectedCollection = nil
    }
}
