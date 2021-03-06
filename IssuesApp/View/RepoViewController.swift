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
        if identifier == "EnterRepoSegue", let owner = ownerTextField.text, let repo = repoTextField.text {
            return !(owner.isEmpty || repo.isEmpty)
        }
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "EnterRepoSegue" {
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return }
            GlobalState.instance.owner = owner
            GlobalState.instance.repo = repo
            GlobalState.instance.addRepo(owner: owner, repo: repo)
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
    
    @IBAction func unwindFromRepos(_ segue: UIStoryboardSegue) {
        if let reposViewController = segue.source as? ReposViewController, let (owner, repo) = reposViewController.selectedRepo {
            ownerTextField.text = owner
            repoTextField.text = repo
            DispatchQueue.main.async { [weak self] in
                self?.performSegue(withIdentifier: "EnterRepoSegue", sender: self)
                
            }
        }
    }
}
