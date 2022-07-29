//
//  UserPostsViewController.swift
//  social_network
//
//  Created by admin on 7/21/22.
//

import UIKit

class UserPostsViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!

    let viewModel = UserPostViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "My Posts"
        viewModel.getUserPosts { result in
            switch result {
            case.success(()):
                self.postTableView.reloadData()
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }
        postTableView.delegate = self
        postTableView.dataSource = self
        postTableView.register(UINib(nibName: PostTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
    }


    @IBAction func addPostButton(_ sender: Any) {
        let vc = PostDetailViewController()
        vc.createNewPost = true
        show(vc, sender: nil)
    }

}

extension UserPostsViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.numberOfPostsInSection
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let post = viewModel.getPostBy(index: indexPath.row)
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else {
            return UITableViewCell()
        }
        cell.post = post
        cell.setTableCell(isForEditting: true, context: self)
        return cell
    }

}
