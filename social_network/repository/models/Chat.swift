//
//  Chat.swift
//  social_network
//
//  Created by admin on 8/1/22.
//

import Foundation
import Firebase
import FirebaseFirestoreSwift

struct Chat: BaseModel, Codable {
    @DocumentID var id: String?
    var participantsId: [String]
    var participants: [User]
    var lastMsg: String
    @ServerTimestamp var createdAt: Timestamp?
}
