//
//  RepoViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 7..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var repoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}

extension RepoViewController {
    @IBAction func logoutButtonTapped(_ sender: Any) {
        GlobalState.instance.token = ""
        let loginViewController = LoginViewController.viewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0, execute: {[weak self] in
            self?.present(loginViewController, animated: true, completion: nil)
        })
    }
}
