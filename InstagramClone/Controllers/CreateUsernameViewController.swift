//
//  CreateUsernameViewController.swift
//  InstagramClone
//
//  Created by MacBookPro on 1/30/18.
//  Copyright © 2018 basicdas. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class CreateUsernameViewController: UIViewController {
    
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var nextButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nextButton.layer.cornerRadius = 5
        self.nextButton.layer.masksToBounds = true
    }
    
    
    @IBAction func nextButtonTapped(_ sender: UIButton) {
        guard let firUser = Auth.auth().currentUser, let username = usernameTextField.text, !username.isEmpty else {
            return
        }
        
        
        UserService.create(firUser, username: username) { (user) in
            guard let user = user else { return }
            User.setCurrent(user)
            
            let initialViewController = UIStoryboard.initialViewController(for: .main)
            self.view.window?.rootViewController = initialViewController
            self.view.window?.makeKeyAndVisible()
        }
    }
    
}
