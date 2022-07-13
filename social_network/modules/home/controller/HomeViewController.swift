//
//  HomeViewController.swift
//  social_network
//
//  Created by admin on 7/7/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {
    let firebaseManager = FirebaseManager.shared

    @IBOutlet weak var userName: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        FirebaseUserManager.shared.getCurrentUser { result in
            switch result {
            case.success(let user):
                self.userName.text = user.username
            case.failure(let error):
                print(error)
            }
        }

        
    }
    

    @IBAction func logoutButtonPressed(_ sender: Any) {
        FirebaseAuthManager.shared.signOut { error in
            print(error)
        }
    }

}
