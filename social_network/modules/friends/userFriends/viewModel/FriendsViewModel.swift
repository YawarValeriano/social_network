//
//  FriendsViewModel.swift
//  social_network
//
//  Created by admin on 7/30/22.
//

import Foundation

class FriendsViewModel {

    private var friendList = [User]()

    var numbersOfFriends: Int {
        friendList.count
    }

    func getFriendList(completion: ((Result<Void, Error>) -> Void)?) {
        FirebaseUserManager.shared.getAcceptedFriendRequest { result in
            switch result {
            case.success(let users):
                self.friendList = users
                completion?(.success(()))
            case.failure(let error):
                completion?(.failure(error))
            }
        }
    }

    func getUserBy(index: Int) -> User {
        friendList[index]
    }
}
