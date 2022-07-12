import Foundation

struct User: Codable, BaseModel {
    var id: String
    let name: String
    let age: Int
}
