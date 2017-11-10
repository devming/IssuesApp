//
//  RepoViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 7..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {
    
    @IBOutlet weak var ownerTextField: UITextField!
    @IBOutlet weak var repoTextField: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        ownerTextField.text = GlobalState.instance.owner
        repoTextField.text = GlobalState.instance.repo
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        guard let owner = ownerTextField.text, let repo = repoTextField.text else { return false }
        return !(owner.isEmpty || repo.isEmpty)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EnterRepoSegue" {
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return }
            GlobalState.instance.owner = owner
            GlobalState.instance.repo = repo
        }
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
