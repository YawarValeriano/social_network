//
//  UserListTableViewCell.swift
//  social_network
//
//  Created by admin on 7/24/22.
//

import UIKit

class UserListTableViewCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var userStatusLabel: UILabel!

    var user: User?

    static let nibName = "UserListTableViewCell"
    static let identifier = "UserListTableViewCell"

    override func awakeFromNib() {
        super.awakeFromNib()
        userImageView.layer.cornerRadius = userImageView.layer.bounds.height/2
        userImageView.clipsToBounds = true
        userImageView.layer.borderWidth = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    func setData() {
        guard let user = user else { return }
        usernameLabel.text = user.username
        userStatusLabel.text = user.userStatus
        guard let imageUrl = URL(string: user.imageUrl) else { return }
        userImageView.image = ImageManager.shared.getUIImage(formURL: imageUrl)
    }
    
}
