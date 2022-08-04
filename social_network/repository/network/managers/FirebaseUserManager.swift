//
//  FirebaseUserManager.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

class FirebaseUserManager {
    static let shared = FirebaseUserManager()

    private let db = Firestore.firestore()


    func getUserUid() -> String {
        Auth.auth().currentUser?.uid ?? ""
    }

    func getCurrentUser(completion: @escaping(Result<User, Error>) -> Void) {
        let user = getUserUid()
        let docRef = db.collection(FirebaseCollections.users.rawValue).document(user)

        docRef.getDocument { (document, error) in
            guard error == nil else {
                completion(.failure(FirebaseError.errorInFirebase))
                return
            }

            if let document = document, document.exists {
                do {
                    let json = JSONDecoder()
                    let data = try JSONSerialization.data(withJSONObject: document.data() ?? [], options: [])
                    let item = try json.decode(User.self, from: data)
                    completion(.success(item))
                } catch let error {
                    completion(.failure(error))
                }

            } else {
                completion(.failure(FirebaseError.noDocument))
            }
        }
    }

    func getUserPosts(completion: @escaping ( Result<[Post], Error>) -> Void  ) {
        let user = getUserUid()
        db.collection(FirebaseCollections.posts.rawValue).whereField("userId", isEqualTo: user).order(by: "createdAt", descending: true).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }

            var items = [Post]()
            for document in documents {
                if let item = try? document.data(as: Post.self) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }

    func getRequestStatus(receiverId: String, completion: @escaping (Result<FriendRequest, Error>) -> Void) {
        let user = getUserUid()
        db.collection(FirebaseCollections.friendRequests.rawValue).whereField("participants", in: [[user, receiverId], [receiverId, user]]).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success(FriendRequest(senderUserId: user, receiverUserId: receiverId, participants: [user, receiverId], status: .NewRequest))) }
            if documents.isEmpty {
                completion(.success(FriendRequest(senderUserId: user, receiverUserId: receiverId, participants: [user, receiverId], status: .NewRequest)))
            } else {
                let request = try? documents[0].data(as: FriendRequest.self)
                completion(.success(request!))
            }
        }
    }

    func getAcceptedFriendRequest(completion: @escaping (Result<[User], Error>) -> Void) {
        let user = getUserUid()
        db.collection(FirebaseCollections.friendRequests.rawValue).whereField("participants", arrayContains: user).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            var items = [User]()
            for document in documents {
                if let item = try? document.data(as: User.self) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
}
