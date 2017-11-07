//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    static var viewController: LoginViewController {
        guard let viewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as? LoginViewController else {
            return LoginViewController()
        }
        return viewController
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginToGitHubButtonTapped(_ sender: UIButton) {
        App.api.getToken { [weak self] in
            self?.dismiss(animated: true, completion: nil)
            
        }
        
    }
}
