import Foundation

struct Collection: Identifiable, Codable, Hashable {
    let id: UUID
    var name: String
    var dateCreated: Date
    var dateModified: Date

    init(id: UUID = UUID(), name: String) {
        self.id = id
        self.name = name
        self.dateCreated = Date()
        self.dateModified = Date()
    }
}
