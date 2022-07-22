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

    var post: Post?

    override func awakeFromNib() {
        super.awakeFromNib()

        borderView.layer.borderWidth = 1
        borderView.layer.cornerRadius = 5

    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func setTableCell() {
        guard let cellPost = self.post else { return }
        self.userNameLabel.text = "User name"
        self.descriptionLabel.text = cellPost.description
        self.postDateLabel.text = cellPost.createdAt.toString(stringFormat: "MMM d, yyyy")
        if let image = cellPost.urlImage, let url = URL(string: image) {
            self.postImageView.image = ImageManager.shared.getUIImage(formURL: url)
        } else {
            self.postImageView.isHidden = true
            self.imageHeight.constant = 0
            self.topStackConstraint.constant = 0
        }
    }

}
