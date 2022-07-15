//
//  LoginViewController.swift
//  social_network
//
//  Created by admin on 7/14/22.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
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
