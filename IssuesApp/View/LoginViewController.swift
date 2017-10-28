//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginToGitHubButtonTapped(_ sender: UIButton) {
        App.api.getToken {
            
        }
        
    }
}
