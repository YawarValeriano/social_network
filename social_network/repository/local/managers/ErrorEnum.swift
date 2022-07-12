//
//  AuthErrorEnum.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation

enum AuthError: Error {
    case wrongCredentials
    case userNotLoggedIn
}

enum FirebaseError: Error {
    case errorInFirebase
    case noDocument
}
