//
//  PostDetailViewModel.swift
//  social_network
//
//  Created by admin on 7/18/22.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import UIKit

class PostDetailViewModel {
    let storage = Storage.storage()

    private let firebaseManager = FirebaseManager.shared

    func savePost(urlMovie: String?, description: String, category: CategoryType, hasChangedImage: Bool, image: Data, completion: ((Result<Void, Error>) -> Void)?) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let storageRef = storage.reference()
        let docId = firebaseManager.getDocID(forCollection: .posts)
        let photoRef = storageRef.child("\(FirebaseCollections.posts.rawValue)/\(docId).jpeg")

        var username = ""
        var userPic = ""
        if let name = UserDefaults.standard.string(forKey: FirebaseAuthManager.nameUserKey), let pic = UserDefaults.standard.string(forKey: FirebaseAuthManager.urlImageKey) {
            username = name
            userPic = pic
        }

        if  hasChangedImage {
            firebaseManager.uploadFile(fileData: image, storageReference: photoRef) { result in
                switch result {
                case.success(let downloadURL):
                    let post = Post(userPic: userPic, userName: username, userId: uid,urlMovie: urlMovie, urlImage: downloadURL, description: description, category: category)
                    self.firebaseManager.addDocument(document: post, docId: docId, collection: .posts) { result in
                        switch result {
                        case .success(let post):
                            print("Success", post)
                            completion?(.success(()))
                        case .failure(let error):
                            completion?(.failure(error))
                        }
                    }
                case.failure(let error):
                    completion?(.failure(error))
                }
            }

        } else {
            let post = Post(userPic: userPic, userName: username, userId: uid, urlMovie: urlMovie, urlImage: nil, description: description, category: category)
            firebaseManager.addDocument(document: post, docId: docId, collection: .posts) { result in
                switch result {
                case .success(let post):
                    print("Success", post)
                    completion?(.success(()))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }

    func updatePost(documentId: String, urlMovie: String?, description: String, category: CategoryType,
            oldUrlImage: String?, hasChangedImage: Bool, imageData: Data, completion: ((Result<Void, Error>) -> Void)?) {
        var username = ""
        var userPic = ""
        if let name = UserDefaults.standard.string(forKey: FirebaseAuthManager.nameUserKey), let pic = UserDefaults.standard.string(forKey: FirebaseAuthManager.urlImageKey) {
            username = name
            userPic = pic
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        if hasChangedImage {
            let storageRef = storage.reference()
            let photoRef = storageRef.child("\(FirebaseCollections.posts.rawValue)/\(documentId).jpeg")
            firebaseManager.uploadFile(fileData: imageData, storageReference: photoRef) { result in
                switch result {
                case.success(let downloadURL):
                    let post = Post(id: documentId, userPic: userPic, userName: username, userId: uid, urlMovie: urlMovie, urlImage: downloadURL, description: description, category: category)
                    self.firebaseManager.updateDocument(document: post, collection: .posts) { result in
                        switch result {
                        case .success(let post):
                            print("Success", post)
                            completion?(.success(()))
                        case .failure(let error):
                            completion?(.failure(error))
                        }
                    }
                case.failure(let error):
                    completion?(.failure(error))
                }
            }
        } else {
            let post = Post(id: documentId, userPic: userPic, userName: username, userId: uid, urlMovie: urlMovie, urlImage: oldUrlImage, description: description, category: category)
            firebaseManager.updateDocument(document: post, collection: .posts) { result in
                switch result {
                case .success(let post):
                    print("Success", post)
                    completion?(.success(()))
                case .failure(let error):
                    completion?(.failure(error))
                }
            }
        }
    }

}
