//
//  FirebaseAuthManager.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation
import FirebaseAuth

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()

    private let auth = Auth.auth()

    func checkUserLoggedIn(completion: @escaping(Result<Void, Error>) -> Void) {
        auth.addStateDidChangeListener() { auth, user in
            if user != nil {
                completion(.success(()))
            } else {
                completion(.failure(AuthError.userNotLoggedIn))
            }
        }
    }

    func signIn(email: String, password: String, completion: @escaping(Result<Void, Error>) -> Void) {
        auth.signIn(withEmail: email, password: password) { _, error in
            if let error = error {
                completion(.failure(error))
            }
            completion(.success(()))
        }
    }

    func signUp(email: String, password: String, username: String, city: String, userStatus: String, completion: @escaping(Result<User, Error>) -> Void) {
        auth.createUser(withEmail: email, password: password) { result, error in
            if let error = error {
                completion(.failure(error))
            } else {
                let uid = result?.user.uid

                let user = User(id: uid!, username: username, city: city, userStatus: userStatus)

                FirebaseManager.shared.addDocument(document: user, docId: uid!, collection: .users) { result in
                    switch result {
                    case.success(let user):
                        completion(.success(user))
                    case.failure(let error):
                        self.auth.currentUser?.delete()
                        completion(.failure(error))
                    }
                }
            }

        }
    }

    func signOut(errorMsg: @escaping(String) -> Void) {
        do {
            try auth.signOut()
        } catch let error {
            errorMsg(error.localizedDescription)
        }
    }

}
