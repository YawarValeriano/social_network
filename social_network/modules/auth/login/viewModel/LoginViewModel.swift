//
//  LoginViewModel.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation

class LoginViewModel {
    
    static let shared = LoginViewModel()

    func login(email: String, password: String, completion: @escaping (Result<Void, Error>) -> Void ) {
        FirebaseAuthManager.shared.signIn(email: email, password: password) { result in
            completion(result)
        }

    }
}
