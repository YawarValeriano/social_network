//
//  FloatingActionButton.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import UIKit

class FloatingActionButton: UIButton {

    override func awakeFromNib() {
        super.awakeFromNib()

        self.widthAnchor.constraint(equalToConstant: 56).isActive = true
        self.heightAnchor.constraint(equalToConstant: 56).isActive = true

        self.layer.cornerRadius = 28

        self.setImage(UIImage(systemName: "plus"), for: .normal)
        self.backgroundColor = UIColor(named: "MainColor")
        self.tintColor = .white

        self.setTitle("", for: .normal)

        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = CGSize(width: 0, height: 1)
        self.layer.shadowOpacity = 0.5
        self.layer.shadowRadius = 3.0

    }
}
