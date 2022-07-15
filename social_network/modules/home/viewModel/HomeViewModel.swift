//
//  HomeViewModel.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import Foundation

class HomeViewModel {
    static let shared = HomeViewModel()

    func getPosts(completion: @escaping(Result<[Post], Error>) -> Void) {
        FirebaseManager.shared.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case.success(let posts):
                completion(.success(posts))
            case.failure(let error):
                completion(.failure(error))
            }
        }
    }
}
