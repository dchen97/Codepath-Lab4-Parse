//
//  LoginViewController.swift
//  Codepath-lab4-parse
//
//  Created by Diana C on 2/21/17.
//  Copyright © 2017 Diana C. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        signUpButton.addTarget(self, action: #selector(LoginViewController.signUp), for: .touchUpInside)
        
        emailTextField.delegate = self
        
        passwordTextField.delegate = self
        
        loginButton.addTarget(self, action: #selector(LoginViewController.logIn), for: .touchUpInside)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.setEditing(false, animated: true)
    }
    
    func signUp() {
        if (self.emailTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter a username", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            print("No username")
            return
        }
        if (self.passwordTextField.text?.isEmpty
            )! {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter your password", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: {() in print("alert dismissed")})
            print("No password")
            return
        }

        let newUser = PFUser()
        newUser.username = emailTextField.text
        newUser.password = passwordTextField.text
        
        newUser.signUpInBackground(block: { (succeed, error) -> Void in
            if (error != nil) {
                let alertController = UIAlertController(title: "Sign Up Error", message: "There was an unexpected error signing you up. Please try again.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                print("Sign up error")
            } else {
                let chatVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController"))
                self.present(chatVC!, animated: true, completion: nil)
                print("Success with signing up!")
            }
        })
    }
    
    func logIn() {
        if (self.emailTextField.text?.isEmpty)! {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter a username", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: nil)
            print("No username")
            return
        }
        if (self.passwordTextField.text?.isEmpty
            )! {
            let alertController = UIAlertController(title: "Sign Up Error", message: "Please enter your password", preferredStyle: .alert)
            let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(cancelAction)
            self.present(alertController, animated: true, completion: {() in print("alert dismissed")})
            print("No password")
            return
        }

        PFUser.logInWithUsername(inBackground: emailTextField.text!, password: passwordTextField.text!, block: { (succeed, error) -> Void in
            if (error != nil) {
                let alertController = UIAlertController(title: "Sign In Error", message: "There was an unexpected error signing you in. Please try again.", preferredStyle: .alert)
                let cancelAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
                print("Error signing in")
            } else {
                let chatVC = (self.storyboard?.instantiateViewController(withIdentifier: "ChatViewController"))
                self.present(chatVC!, animated: true, completion: nil)
                print("Success signing in!")
            }
        })
    }
    
    func dismissKeyboard() {
        self.setEditing(false, animated: true)
    }
  
}
