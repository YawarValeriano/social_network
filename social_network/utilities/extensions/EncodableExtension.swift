import Foundation
import FirebaseFirestore

extension Encodable {

    var dict : [String: Any]? {
        guard let data = try? Firestore.Encoder().encode(self) else { return nil }
        return data
    }
}
