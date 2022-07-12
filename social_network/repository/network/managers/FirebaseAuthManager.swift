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
            guard error == nil else {
                completion(.failure(AuthError.wrongCredentials))
                return
            }
            completion(.success(()))
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
