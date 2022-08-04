//
//  FriendsViewController.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import UIKit

class FriendsViewController: UIViewController {

    var viewModel = FriendsViewModel()

    @IBOutlet weak var friendsTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        friendsTableView.dataSource = self
        friendsTableView.delegate = self
        friendsTableView.register(UINib(nibName: UserListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserListTableViewCell.identifier)
        viewModel.getFriendList { result in
            switch result {
            case.success(()):
                self.friendsTableView.reloadData()
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }
    }

    @IBAction func showUserList(_ sender: Any) {
        let vc = SearchFriendsViewController()
        show(vc, sender: nil)
    }

}

extension FriendsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numbersOfFriends
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.getUserBy(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as? UserListTableViewCell else { return UITableViewCell() }
        cell.user = user
        cell.setData()
        return cell
    }

    
}
