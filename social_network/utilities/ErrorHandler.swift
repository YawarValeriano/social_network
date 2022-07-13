//
//  File.swift
//  social_network
//
//  Created by admin on 7/10/22.
//

import Foundation
import UIKit

class ErrorHandler {
    static let shared = ErrorHandler()

    func showError(withDescription error: String, viewController: UIViewController) {
        let alert = UIAlertController(title: "Error", message: error, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            print("OK")
        }))
        viewController.present(alert, animated: true, completion: nil)
    }
}
