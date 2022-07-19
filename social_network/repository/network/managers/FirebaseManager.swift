import Foundation
import Firebase
import FirebaseFirestoreSwift


enum FirebaseErrors: Error {
    case ErrorToDecodeItem
}

enum FirebaseCollections: String {
    case users
    case posts
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
        db.collection(collection.rawValue).addSnapshotListener { querySnapshot, error in
            guard error == nil else { return completion(.failure(error!)) }
            guard let documents = querySnapshot?.documents else { return completion(.success([])) }
            
            
            var items = [T]()
            let json = JSONDecoder()
            for document in documents {
                if let data = try? JSONSerialization.data(withJSONObject: document.data(), options: []),
                   let item = try? json.decode(type, from: data) {
                    items.append(item)
                }
            }
            completion(.success(items))
        }
    }
    
    
    func addDocument<T: Encodable>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document().setData(itemDict) { error in
            if let error = error {
                completion(.failure(error))
            } else {
                completion(.success(document))
            }
        }
        
    }

    
    
    func updateDocument<T: Encodable>(document: T, collection: FirebaseCollections, completion: @escaping ( Result<T, Error>) -> Void  ) {
        guard let itemDict = document.dict else { return completion(.failure(FirebaseErrors.ErrorToDecodeItem)) }
        
        db.collection(collection.rawValue).document().setData(itemDict) { error in
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
