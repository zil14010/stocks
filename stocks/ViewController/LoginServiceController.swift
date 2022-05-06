//
//  LoginServiceController.swift
//  stocks
//
//  Created by zipeng lin on 4/24/22.
//  Copyright © 2022 dk. All rights reserved.
//


import Foundation
import UIKit
import Firebase

class LoginViewController: UIViewController {

    var userDefault = UserDefaults.standard
    var launchedBefore = UserDefaults.standard.bool(forKey: "usersignedin")
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
    
    override func viewDidAppear(_ animated: Bool) {
        if userDefault.bool(forKey: "usersignedin") {
                  performSegue(withIdentifier: "Verified", sender: self)
              }
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
           // var credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
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
            UserDefaults.standard.set(Auth.auth().currentUser!.uid, forKey: "username")
            UserDefaults.standard.synchronize()
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let UserInfoViewController = storyBoard.instantiateViewController(withIdentifier: "tab") as! UITabBarController
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(UserInfoViewController)
            self.present(UserInfoViewController, animated: true, completion: nil)
            }
    
        })
    }
    
    func showError(userError: NSError) {
        let alert = UIAlertController(title: "Login Error", message: userError.localizedDescription, preferredStyle: .alert)
        let action = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
}
