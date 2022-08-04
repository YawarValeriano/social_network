import Foundation
import Firebase

protocol BaseModel {
    var id: String? { get set }
    var createdAt: Timestamp? { get set }
}
