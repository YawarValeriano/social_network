//
//  SignUpViewController.swift
//  social_network
//
//  Created by admin on 7/12/22.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var birthdayDatePicker: UIDatePicker!
    @IBOutlet weak var cityTextField: UITextField!
    @IBOutlet weak var statusTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func continueButtonPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text, let username = usernameTextField.text,
              let city = cityTextField.text, let status = statusTextField.text else {
            ErrorHandler.shared.showError(withDescription: "Fields are not completed. Please fill the information requiered", viewController: self)
            return
        }

        FirebaseAuthManager.shared.signUp(email: email, password: password, username: username, city: city, userStatus: status) { result in
            switch result {
            case.success(let user):
                print(user.id)
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            }
        }

        
    }
    
}
