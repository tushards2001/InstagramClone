//
//  LoginViewController.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/30/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseAuthUI
import FirebaseDatabase

typealias FIRUser = FirebaseAuth.User

class LoginViewController: UIViewController {
    
    @IBOutlet weak var loginButton: UIButton!
    
    
    //let user: FIRUser? = Auth.auth().currentUser
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loginButton.layer.cornerRadius = 5
        self.loginButton.layer.masksToBounds = true
    }
    
    
    @IBAction func loginButtonTapped(_ sender: UIButton) {
        print("Login Button Tapped")
        
        guard let authUI = FUIAuth.defaultAuthUI() else { return }
        authUI.delegate = self
        
        let authViewController = authUI.authViewController()
        present(authViewController, animated: true, completion: nil)
    }
}

extension LoginViewController: FUIAuthDelegate {
    
    func authUI(_ authUI: FUIAuth, didSignInWith user: FIRUser?, error: Error?) {
        if let error = error {
            assertionFailure("Error Signing In: \(error.localizedDescription)")
            return
        }
        
        
        if let fbUser = Auth.auth().currentUser {
            UserService.show(forUID: fbUser.uid, completion: { (user) in
                if let user = user {
                    User.setCurrent(user, writeToUserDefaults: true)
                    
                    let initialViewController = UIStoryboard.initialViewController(for: .main)
                    self.view.window?.rootViewController = initialViewController
                    self.view.window?.makeKeyAndVisible()
                } else {
                    print("New user!")
                    self.performSegue(withIdentifier: Constants.Segue.toCreateUsername, sender: self)
                }
            })
            
            
        }
        
        print("handle sign up/login")
    }
}
