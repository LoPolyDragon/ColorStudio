import Foundation
import Combine

class CollectionViewModel: ObservableObject {
    @Published var collections: [Collection] = []

    private let collectionsKey = "ColorStudio.Collections"

    init() {
        loadCollections()
    }

    func addCollection(name: String) {
        let collection = Collection(name: name)
        collections.append(collection)
        saveCollections()
    }

    func deleteCollection(_ collection: Collection) {
        collections.removeAll { $0.id == collection.id }
        saveCollections()
    }

    func updateCollection(_ collection: Collection) {
        if let index = collections.firstIndex(where: { $0.id == collection.id }) {
            collections[index] = collection
            saveCollections()
        }
    }

    private func saveCollections() {
        if let encoded = try? JSONEncoder().encode(collections) {
            UserDefaults.standard.set(encoded, forKey: collectionsKey)
        }
    }

    private func loadCollections() {
        if let data = UserDefaults.standard.data(forKey: collectionsKey),
           let decoded = try? JSONDecoder().decode([Collection].self, from: data) {
            collections = decoded
        } else {
            collections = [
                Collection(name: "All Palettes")
            ]
            saveCollections()
        }
    }
}
