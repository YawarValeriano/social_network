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
    let	userId: String
    let urlMovie: String
    let urlImage: String?
    let description: String
    let categoryId: String
    let createdAt: Date
}
