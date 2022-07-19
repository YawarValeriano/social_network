//
//  HomeViewModel.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import Foundation

class HomeViewModel {

    private var posts = [Post]()

    var numberOfItemsInSsction: Int {
        posts.count
    }

    func getPosts(completion: ((Result<Void, Error>) -> Void)?) {
        FirebaseManager.shared.getDocuments(type: Post.self, forCollection: .posts) { result in
            switch result {
            case.success(let postsResult):
                self.posts = postsResult
                completion?(.success(()))
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getPostBy(index: Int) -> Post {
        return posts[index]
    }
}
