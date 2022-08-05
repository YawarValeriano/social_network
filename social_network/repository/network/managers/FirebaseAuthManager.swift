//
//  FirebaseAuthManager.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseAuthManager {
    static let shared = FirebaseAuthManager()
    static let nameUserKey = "name_key"
    static let urlImageKey = "url_key"

    let auth = Auth.auth()

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
        auth.signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }

            if let error = error {
                completion(.failure(error))
            }
            print(strongSelf.auth.currentUser?.uid ?? "no user")
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

    func saveUserData() {
        FirebaseUserManager.shared.getCurrentUser { result in
            switch result {
            case.success(let currUser):
                UserDefaults.standard.set(currUser.imageUrl, forKey: FirebaseAuthManager.urlImageKey)
                UserDefaults.standard.set(currUser.username, forKey: FirebaseAuthManager.nameUserKey)
                print(currUser)
            case.failure(let error):
                print(error.localizedDescription)
            }
        }
    }

}
