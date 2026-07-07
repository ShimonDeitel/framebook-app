import Foundation

struct Job: Identifiable, Codable, Equatable {
    let id: UUID
    var dateCreated: Date
    var title: String
    var width: Double
    var height: Double
    var matSize: String
    var molding: String
    var glassType: String

    init(id: UUID = UUID(), dateCreated: Date = Date(), title: String = "", width: Double = 0, height: Double = 0, matSize: String = "", molding: String = "", glassType: String = "") {
        self.id = id
        self.dateCreated = dateCreated
        self.title = title
        self.width = width
        self.height = height
        self.matSize = matSize
        self.molding = molding
        self.glassType = glassType
    }
}
