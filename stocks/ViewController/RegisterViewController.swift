//
//  RegisterViewController.swift
//  HW3
//
//  Created by zipeng lin on 4/17/22.
//  Copyright © 2022 dk. All rights reserved.

import Foundation
import Firebase

import UIKit

class RegisterViewController: UIViewController {

    @IBOutlet weak var userEmailTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userPasswordTextField.isSecureTextEntry = true
    }

    @IBAction func userClickedCreatAccount(_ sender: UIButton) {
        guard let email = userEmailTextField.text, let password = userPasswordTextField.text else {
            showError()
            return
        }
        Auth.auth().createUser(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                self.showError()
                if let UserInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "Create") as? RegisterViewController {
                    self.present(UserInfoViewController, animated: true, completion: nil)
                }
            }
            
            else{
                if let UserInfoViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController{
                    self.present(UserInfoViewController, animated: true, completion: nil)
                }
            }
            

            
            //self.present(profileController, animated: true, completion: nil)
            //self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @IBAction func userClickedLogin(_ sender: UIButton) {
        if let loginViewController = self.storyboard?.instantiateViewController(withIdentifier: "Login") as? LoginViewController {
            loginViewController.modalPresentationStyle = .fullScreen
            self.present(loginViewController, animated: true, completion: nil)
        }
    }
    
    func showError() {
        let alert = UIAlertController(title: "Create User Error", message: "credential incorrect", preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}

