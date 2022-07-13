//
//  LoginViewController.swift
//  social_network
//
//  Created by admin on 7/6/22.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginPressed(_ sender: Any) {
        let email = emailTextField.text!
        let password = passwordTextField.text!
        LoginViewModel.shared.login(email: email, password: password) { result in
            switch result {
            case.failure(let error):
                ErrorHandler.shared.showError(withDescription: error.localizedDescription, viewController: self)
            case.success(()):
                break
            }
        }
    }

    @IBAction private func signUpPressed(_ sender: Any) {
        let secondViewController = SignUpViewController()
        show(secondViewController, sender: nil)
    }

    @IBAction func forgotPasswordPressed(_ sender: Any) {
    }

}
