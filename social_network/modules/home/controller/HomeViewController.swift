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

    var posts = [Post]()
    let firebaseManager = FirebaseManager.shared

    override func viewDidLoad() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gear"), style: .plain, target: self, action: #selector(showOptionsAlert))
        setupTable()
        initData()

    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        initData()
    }

    func initData() {
        HomeViewModel.shared.getPosts { result in
            switch result {
            case.success(let posts):
                self.posts = posts
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
    }

    @IBAction func addPostButton(_ sender: Any) {
        let postId = firebaseManager.getDocID(forCollection: .posts)
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let post = Post(id: postId, userId: uid, urlMovie: "Url", urlImage: "Rurl", description: "this is a desc", categoryId: "3")
        firebaseManager.addDocument(document: post, collection: .posts) { result in
            switch result {
            case .success(let post):
                print("Success", post)
            case .failure(let error):
                print("Error", error)
            }
        }
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        posts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PostTableViewCell.identifier, for: indexPath) as? PostTableViewCell else { return UITableViewCell() }

        return cell
    }

    

    
}
