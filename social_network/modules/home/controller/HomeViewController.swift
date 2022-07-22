//
//  HomeViewController.swift
//  social_network
//
//  Created by admin on 7/7/22.
//

import UIKit
import FirebaseAuth

class HomeViewController: UIViewController {

    @IBOutlet weak var postTableView: UITableView!

    let firebaseManager = FirebaseManager.shared
    var homeViewModel = HomeViewModel()

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showOptionsAlert))
        setupTable()
//        initData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }

    func initData() {
        homeViewModel.getPosts { result in
            switch result {
            case.success(()):
                self.postTableView.reloadData()
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }
    }

    func setupTable() {
        postTableView.register(UINib(nibName: PostTableViewCell.nibName, bundle: nil), forCellReuseIdentifier: PostTableViewCell.identifier)
        postTableView.delegate = self
        postTableView.dataSource = self
//        postTableView.rowHeight = UITableView.automaticDimension
//        postTableView.estimatedRowHeight = 300

    }

    @IBAction func addPostButton(_ sender: Any) {
        let vc = PostDetailViewController()
        vc.createNewPost = true
        show(vc, sender: nil)
    }
    
    @objc
    fileprivate func showOptionsAlert() {
        DispatchQueue.main.async {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

            sheet.addAction(UIAlertAction(title: "My Posts", style: .default) { _ in
                print("Show My posts")
            })

            sheet.addAction(UIAlertAction(title: "Friend Requests", style: .default) { _ in
                print("show Friend Requests")
            })

            sheet.addAction(UIAlertAction(title: "Profile", style: .default) { _ in
                print("Show profile")
            })
            
            sheet.addAction(UIAlertAction(title: "Log Out", style: .cancel, handler: { _ in
                FirebaseAuthManager.shared.signOut { error in
                    print(error)
                }
            }))

            self.navigationController?.present(sheet, animated: true, completion: nil)

        }
    }
}


// MARK: UITableView delegate
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        homeViewModel.numberOfItemsInSsction
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }
        let post = homeViewModel.getPostBy(index: indexPath.row)
        cell.post = post
        cell.setTableCell()
        return cell
    }
}
