//
//  ViewController.swift
//  DemoFireBase
//
//  Created by namtrinh on 30/12/2020.
//

import UIKit
import FirebaseAuth

class LogInViewController: UIViewController {

    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        dismissKeyboard()
        setUp()
    }

    private func setUp(){
        loginButton.layer.cornerRadius = 10
        usernameTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        //passwordTextField.isSecureTextEntry = true
    }
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
        handelNotAuthenticated()
        usernameTextField.text = ""
        passwordTextField.text = ""
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
    }
    private func handelNotAuthenticated() {
        if Auth.auth().currentUser != nil {
           //  Show home
            let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    @IBAction func handelLogInButton(_ sender: Any) {
        print("Log in tapped")
        guard let usernameEmail = usernameTextField.text, !usernameEmail.isEmpty,
              let password = passwordTextField.text, !password.isEmpty, password.count >= 8  else {
            return
        }
        AuthManager.shared.loginUser(email: usernameEmail,password: password) { success in
            DispatchQueue.main.async {
                if success {
                    print("Logged")
                    let vc = self.storyboard?.instantiateViewController(identifier: "HomeViewController") as! HomeViewController
                    self.navigationController?.pushViewController(vc, animated: true)
                }
                else {
                    let alert = UIAlertController(title: "Log In Error",
                                                  message: "We were ubnable to log you in.",
                                                  preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "Dismiss",
                                                  style: .cancel,
                                                  handler: nil))
                    self.present(alert, animated: true)
                }
            }
        }
    }

}
extension UIViewController {
    func dismissKeyboard() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer( target: self, action:    #selector(UIViewController.dismissKeyboardTouchOutside))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        }
        
    @objc private func dismissKeyboardTouchOutside() {
        view.endEditing(true)
        }
}

extension LogInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.usernameTextField.resignFirstResponder()
        self.passwordTextField.resignFirstResponder()
        return true
    }

}
