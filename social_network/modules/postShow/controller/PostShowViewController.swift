//
//  PostShowViewController.swift
//  social_network
//
//  Created by admin on 8/2/22.
//

import UIKit

class PostShowViewController: UIViewController {

    var post: Post?
    @IBOutlet weak var movieLinkStack: UIStackView!

    @IBOutlet weak var postImage: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    @IBOutlet weak var imageHeightConstraint: NSLayoutConstraint!
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Post Detail"
        setDetailData()
    }

    func setDetailData() {
        guard let post = post else {
            return
        }
        usernameLabel.text = post.userName
        categoryLabel.text = post.category.rawValue
        descriptionLabel.text = post.description
        if let urlMovie = post.urlMovie, urlMovie.isEmpty {
            movieLinkStack.isHidden = true
        }
        guard let urlImage = post.urlImage, let url = URL(string: urlImage) else {
            let newConstraint = imageHeightConstraint.constraintWithMultiplier(0)
            view.removeConstraint(imageHeightConstraint)
            view.addConstraint(newConstraint)
            view.layoutIfNeeded()
            imageHeightConstraint = newConstraint
            postImage.isHidden = true
            return
        }
        postImage.image = ImageManager.shared.getUIImage(formURL: url)
    }

    @IBAction func goToPage(_ sender: Any) {
    }
    
}

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
