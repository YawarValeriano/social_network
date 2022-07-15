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


    @IBOutlet weak var thisIsLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
