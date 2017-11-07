//
//  RepoViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 4..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

    @IBOutlet var ownerTextField: UITextField!
    @IBOutlet var repoTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ownerTextField.text = GlobalState.instance.owner
        repoTextField.text = GlobalState.instance.repo

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// segue를 실행할까 말까를 정해주는 메소드
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        
        if identifier == "EnterRepoSegue" {
            guard let owner = ownerTextField.text, let repo = repoTextField.text else { return false }
            return !(owner.isEmpty || repo.isEmpty) // 둘중 하나라도 비어있으면 실행 안함.
        }
        return true
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    /// Enter를 누르면 show를 통해 다음 뷰컨트롤러가 뜨는데 그기로 이동하기 전에 해당 뷰컨트롤러의 데이터를 셋팅하는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        segue.destination   /// issues viewcontroller
//        segue.source /// self

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
        GlobalState.instance.token = "" // 토큰 지우기
        let loginViewController = LoginViewController.viewController
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.0) { [weak self] in
            self?.present(loginViewController, animated: true, completion: nil)
            
        }
        
    }
    
    @IBAction func unwindFromRepos(_ segue: UIStoryboardSegue) {
        guard let reposViewController = segue.source as? ReposViewController else { return }
        guard let (owner, repo) = reposViewController.selectedRepo else { return }
        
        ownerTextField.text = owner
        repoTextField.text = repo
        
        DispatchQueue.main.async { [weak self] in
            self?.performSegue(withIdentifier: "EnterRepoSegue", sender: nil)
        }
        
    }
}






