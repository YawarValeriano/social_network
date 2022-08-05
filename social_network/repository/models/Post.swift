//
//  File.swift
//  social_network
//
//  Created by admin on 7/11/22.
//

import Foundation
import FirebaseFirestoreSwift
import Firebase

struct Post: Codable, BaseModel {
    @DocumentID var id: String?
    var userPic: String
    var userName: String
    var	userId: String
    var urlMovie: String?
    var urlImage: String?
    var description: String
    var category: CategoryType
    @ServerTimestamp var createdAt: Timestamp?
}
