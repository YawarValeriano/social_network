//
//  PostTableViewCell.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import UIKit

class PostTableViewCell: UITableViewCell {

    static let nibName = "PostTableViewCell"
    static let identifier = "PostTableCellIdentifier"

    @IBOutlet weak var borderView: UIView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var postDateLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var postImageView: UIImageView!
    @IBOutlet weak var commentSummaryLabel: UILabel!
    @IBOutlet weak var topStackConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageHeight: NSLayoutConstraint!
    @IBOutlet weak var postActionButton: UIButton!

    var post: Post?
    var parentContext: UIViewController?
    var itemRow: Int?
    var buttonIsForEditting = false


    override func awakeFromNib() {
        super.awakeFromNib()
        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 5
        postImageView.layer.cornerRadius = 15
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setTableCell(isForEditting: Bool, context: UIViewController) {
        parentContext = context
        buttonIsForEditting = isForEditting
        postActionButton.setTitle(isForEditting ? "Edit Post" : "Comments", for: .normal)
        guard let cellPost = self.post else { return }
        self.userNameLabel.text = "User name"
        self.descriptionLabel.text = cellPost.description
        self.postDateLabel.text = cellPost.createdAt?.toString(stringFormat: "MMM d, yyyy")
        guard let image = cellPost.urlImage, let url = URL(string: image) else {
            self.postImageView.isHidden = true
            self.imageHeight.constant = 0
            self.topStackConstraint.constant = 0
            return
        }
        self.postImageView.image = ImageManager.shared.getUIImage(formURL: url)

    }

    @IBAction func sendToNextView(_ sender: Any) {
        guard let parentContext = parentContext else { return }
        if buttonIsForEditting {
            let vc = PostDetailViewController()
            vc.createNewPost = false
            vc.post = post
            parentContext.show(vc, sender: nil)
        }

    }
}
