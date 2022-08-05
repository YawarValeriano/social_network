import Foundation
import Firebase
import FirebaseStorage
import FirebaseFirestoreSwift


enum FirebaseErrors: Error {
    case ErrorToDecodeItem
}

enum FirebaseCollections: String {
    case users
    case posts
    case friendRequests
    case chats
    case conversation
}

class FirebaseManager {
    static let shared = FirebaseManager()
    let db = Firestore.firestore()
    
    func getDocID(forCollection collection: FirebaseCollections) -> String {
        db.collection(collection.rawValue).document().documentID
    }
    
    func getDocuments<T: Decodable>(type: T.Type, forCollection collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).order(by: "createdAt", descending: true).getDocuments { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            var items = [T]()
            for document in documents {
//                do {
//                    let item = try document.data(as: type)
//                    items.append(item)
//                } catch  {
//                    print(error)
//                    completion(.failure(error))
//                }
                if let item = try? document.data(as: type) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }

    }
    
    func listenCollectionChanges<T: Decodable>(type: T.Type, collection: FirebaseCollections, completion: @escaping ( Result<[T], Error>) -> Void  ) {
        db.collection(collection.rawValue).order(by: "createdAt", descending: true).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            
            var items = [T]()
            for document in documents {
                if let item = try? document.data(as: type) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }

    func uploadFile(fileData: Data, storageReference: StorageReference, completion: @escaping(Result<String, Error>) -> Void) {
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"

        storageReference.putData(fileData, metadata: metadata) { _, error in
            if let err = error {
                completion(.failure(err))
                return
            }
            storageReference.downloadURL { (url, errorUrl) in
                guard let downloadUrl = url else {
                    completion(.failure(errorUrl!))
                    return
                }
                completion(.success(downloadUrl.absoluteString))
            }
        }
    }
    
    func addDocument<T: Encodable>(document: T, docId: String, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {

        do {
            try db.collection(collection.rawValue).document(docId).setData(from: document) { error in
                if let error = error {
                    completion(.failure(error))
                } else {
                    completion(.success(document))
                }
            }
        } catch let saveError {
            completion(.failure(saveError))
        }
    }

    
    
    func updateDocument<T: Encodable & BaseModel>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document(document.id!).updateData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
    }
    
    
    func removeDocument(documentID: String, collection: FirebaseCollections, completion: @escaping ( Result<String, Error>) -> Void  ) {
        
        db.collection(collection.rawValue).document(documentID).delete() { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(documentID))
            }
        }
    }
    
    
    
    
}
