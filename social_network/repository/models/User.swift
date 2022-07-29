import Foundation
import FirebaseFirestoreSwift
import Firebase

struct User: Codable, BaseModel {
    @DocumentID var id: String?
    let username: String
    let city: String
    let userStatus: String
    var imageUrl: String = "https://firebasestorage.googleapis.com/v0/b/social-network-swift.appspot.com/o/profile%2Fdefault.jpg?alt=media&token=d11c0aa8-9e76-4f6f-9b75-8fc6fa562285"
    @ServerTimestamp var createdAt: Timestamp?
}
