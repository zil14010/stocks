//
//  LoginServiceController.swift
//  stocks
//
//  Created by zipeng lin on 4/24/22.
//  Copyright © 2022 dk. All rights reserved.
//

//
//  LoginViewController.swift
//  HW3
//
//  Created by zipeng lin on 4/17/22.
//

import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    
    @IBOutlet weak var userEmailIDTextField: UITextField!
    @IBOutlet weak var userPasswordTextField: UITextField!
  //  var myMasterViewController: MasterViewController?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        userPasswordTextField.isSecureTextEntry = true
    }
    

    
    @IBAction func login_button(_ sender: Any) {
        guard let email = userEmailIDTextField.text, let password = userPasswordTextField.text else {
            let alert = UIAlertController(title: "Login Error", message: "password problem", preferredStyle: .alert)
            let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
            return
        }
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                let alert = UIAlertController(title: "Login Error", message: "password problem", preferredStyle: .alert)
                let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
                alert.addAction(action)
                self.present(alert, animated: true, completion: nil)
                let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
                let UserInfoViewController = storyBoard.instantiateViewController(withIdentifier: "Login") as! LoginViewController
                self.present(UserInfoViewController, animated: true, completion: nil)
                //return
            }
            
            else{
           
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let UserInfoViewController = storyBoard.instantiateViewController(withIdentifier: "navi") as! UINavigationController
            self.present(UserInfoViewController, animated: true, completion: nil)
            }
    
        })
    }
    
  /*  @IBAction func userClickedCreateAccount(_ sender: UIButton) {
        if let RegisterViewController = self.storyboard?.instantiateViewController(withIdentifier: "Create") as? RegisterViewController {
            self.present(RegisterViewController, animated: true, completion: nil)
        }
    }
    */
    func showError(userError: NSError) {
        let alert = UIAlertController(title: "Login Error", message: userError.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
