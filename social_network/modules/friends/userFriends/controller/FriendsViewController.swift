//
//  FriendsViewController.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import UIKit

class FriendsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    @IBAction func showUserList(_ sender: Any) {
        let vc = SearchFriendsViewController()
        show(vc, sender: nil)
    }

}
