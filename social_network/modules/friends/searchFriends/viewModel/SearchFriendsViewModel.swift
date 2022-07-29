//
//  SearchFriendsViewModel.swift
//  social_network
//
//  Created by admin on 7/24/22.
//

import Foundation

class SearchFriendsViewModel {
    private var users = [User]()

    var numberOfUsers: Int {
        users.count
    }

    func getUserList(completion: ((Result<Void, Error>) -> Void)?) {
        FirebaseManager.shared.getDocuments(type: User.self, forCollection: .users) { result in
            switch result {
            case.success(let usersResult):
                self.users = usersResult
                completion?(.success(()))
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getUserFor(index: Int) -> User {
        users[index]
    }

}
