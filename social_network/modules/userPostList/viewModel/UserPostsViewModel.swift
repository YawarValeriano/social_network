//
//  UserPostsViewModel.swift
//  social_network
//
//  Created by admin on 7/23/22.
//

import Foundation

class UserPostViewModel {
    private var userPosts: [Post] = []

    var numberOfPostsInSection: Int {
        userPosts.count
    }
    
    func getUserPosts(completion: ((Result<Void, Error>) -> Void)?) {
        FirebaseUserManager.shared.getUserPosts { result in
            switch result {
            case.success(let posts):
                self.userPosts = posts
                completion?(.success(()))
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getPostBy(index: Int) -> Post {
        return userPosts[index]
    }
}
