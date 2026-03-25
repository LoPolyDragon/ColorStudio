import Foundation

struct Palette: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var colors: [ColorModel]
    var dateCreated: Date
    var dateModified: Date
    var collectionId: UUID?

    init(id: UUID = UUID(), name: String, colors: [ColorModel] = [], collectionId: UUID? = nil) {
        self.id = id
        self.name = name
        self.colors = colors
        self.dateCreated = Date()
        self.dateModified = Date()
        self.collectionId = collectionId
    }

    mutating func addColor(_ color: ColorModel) {
        colors.append(color)
        dateModified = Date()
    }

    mutating func removeColor(at index: Int) {
        guard index < colors.count else { return }
        colors.remove(at: index)
        dateModified = Date()
    }

    mutating func updateColor(at index: Int, with color: ColorModel) {
        guard index < colors.count else { return }
        colors[index] = color
        dateModified = Date()
    }
}
