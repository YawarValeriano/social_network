//
//  File.swift
//  social_network
//
//  Created by admin on 7/11/22.
//

import Foundation
import FirebaseFirestoreSwift

struct Post: Codable {
    @DocumentID var id: String?
    var	userId: String
    var urlMovie: String?
    var urlImage: String?
    var description: String
    var category: CategoryType
    var createdAt: Date
}
