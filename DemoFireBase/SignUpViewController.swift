//
//  SignUpViewController.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//

import UIKit

class SignUpViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var signupButton: UIButton!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setUp()
    }
    
    private func setUp(){
        signupButton.layer.cornerRadius = 10
        emailTextField.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
      //  passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func handelSignUpButton(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty,
              let email = emailTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 8 else {
            return
        }
        AuthManager.shared.registerNewUser(username: username, email: email, password: password) { (registed) in
            if registed {
                let actionSheet = UIAlertController(title: "Success", message: "Create account successfully", preferredStyle: .alert)
                actionSheet.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (UIAlertAction) in
                    self.dismiss(animated: true, completion: nil)
                }))
                self.present(actionSheet, animated: true, completion: nil)
            } else {
                print("Something error...")
            }
        }
        
    }
    
}

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        self.emailTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }

}
