//
//  SearchFriendsViewController.swift
//  social_network
//
//  Created by admin on 7/24/22.
//

import UIKit

class SearchFriendsViewController: UIViewController {

    var viewModel = SearchFriendsViewModel()


    @IBOutlet weak var userListTableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Search People"
        viewModel.getUserList { result in
            switch result {
            case.success(()):
                self.userListTableView.reloadData()
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }
        userListTableView.dataSource = self
        userListTableView.delegate = self
        userListTableView.register(UINib(nibName: UserListTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: UserListTableViewCell.identifier)
    }
    

}

extension SearchFriendsViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfUsers
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let user = viewModel.getUserFor(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: UserListTableViewCell.identifier, for: indexPath) as? UserListTableViewCell else { return UITableViewCell() }
        cell.user = user
        cell.setData()
        return cell
    }

    
}
