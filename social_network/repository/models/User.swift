import Foundation

struct User: Codable, BaseModel {
    var id: String
    let username: String
    let city: String
    let userStatus: String
}
