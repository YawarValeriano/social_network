//
//  FriendRequest.swift
//  social_network
//
//  Created by admin on 7/29/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct FriendRequest: Codable, BaseModel {
    @DocumentID var id: String?
    var senderUserId: String
    var receiverUserId: String
    var participants = [String]()
    var status: FriendRequestStatus
    @ServerTimestamp var createdAt: Timestamp?
    @ServerTimestamp var updatedAt: Timestamp?
}
