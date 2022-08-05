//
//  PublicProfileViewController.swift
//  social_network
//
//  Created by admin on 7/26/22.
//

import UIKit

class PublicProfileViewController: UIViewController {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!
    @IBOutlet weak var userCityLabel: UILabel!
    @IBOutlet weak var userDetailButton: UIButton!
    @IBOutlet weak var rejectRequestButton: UIButton!
    
    var user: User?
    var request: FriendRequest!

    override func viewDidLoad() {
        super.viewDidLoad()
        setData()
    }

    func setData() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        userStatusLabel.text = user.userStatus
        userCityLabel.text = user.city
        guard let url = URL(string: user.imageUrl) else { return }
        userImageView.image = ImageManager.shared.getUIImage(formURL: url)
        FirebaseUserManager.shared.getRequestStatus(receiverId: user.id!) { result in
            switch result {
            case.success(let req):
                self.request = req
                if req.senderUserId == req.receiverUserId {
                    self.userDetailButton.isHidden = true
                } else {
                    switch req.status {
                    case.Pending:
                        if FirebaseUserManager.shared.getUserUid() == req.senderUserId {
                            self.userDetailButton.setTitle("Cancel Request", for: .normal)
                        } else {
                            self.userDetailButton.setTitle("Accept Request", for: .normal)
                            self.rejectRequestButton.isHidden = false
                        }
                    case.Accepted:
                        self.userDetailButton.setTitle("Send Message", for: .normal)
                        self.rejectRequestButton.isHidden = true
                    case.Rejected, .NewRequest:
                        self.userDetailButton.setTitle("Send Request", for: .normal)
                        self.rejectRequestButton.isHidden = true
                    }
                }
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }
    }

    @IBAction func cancelRequestAction(_ sender: Any) {
        let auxRequest = FriendRequest(id: request.id, senderUserId: request.senderUserId, receiverUserId: request.receiverUserId, participants: request.participants, status: .Rejected)
        self.sendRequest(requestToSend: auxRequest)
    }
    
    @IBAction func buttonAction(_ sender: Any) {
//        guard let user = user else { return }
        switch request.status {
        case.NewRequest, .Rejected:
            let currentUser = FirebaseUserManager.shared.getUserUid()
            let docId = request.id ?? FirebaseManager.shared.getDocID(forCollection: .friendRequests)
            let auxRequest = FriendRequest(id: docId, senderUserId: currentUser, receiverUserId: currentUser == request.receiverUserId ? request.senderUserId : request.receiverUserId, participants: [request.senderUserId, request.receiverUserId], status: .Pending)
            self.sendRequest(requestToSend: auxRequest)
        case.Pending:
            let isCurrentUser = FirebaseUserManager.shared.getUserUid() == request.senderUserId
            let auxRequest = FriendRequest(id: request.id, senderUserId: request.senderUserId, receiverUserId: request.receiverUserId, participants: request.participants, status: isCurrentUser ? .Rejected : .Accepted)
            self.sendRequest(requestToSend: auxRequest)
        case.Accepted:
            print("send message")
        }

    }

    private func sendRequest(requestToSend: FriendRequest) {
        if requestToSend.status == .Accepted {
            FirebaseUserManager.shared.addChat(users: [])
        }
        FirebaseManager.shared.addDocument(document: requestToSend, docId: requestToSend.id!, collection: .friendRequests) { result in
            switch result {
            case.failure(let error):
                print(error.localizedDescription)
            case.success(let data):
                print(data)
            }
        }
    }
}
