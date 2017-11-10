//
//  ReposViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 11..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class ReposViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    var selectedRepo: (owner: String, repo: String)?
    let datasource = GlobalState.instance.repos
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }


}

extension ReposViewController {
    func setup() {
        tableView.dataSource = self
        tableView.delegate = self
    }
}

extension ReposViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RepoCell", for: indexPath)
        let data = datasource[indexPath.row]
        cell.textLabel?.text = "/repo/\(data.owner)/\(data.repo)"
        return cell
    }
}

extension ReposViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let data = datasource[indexPath.row]
        selectedRepo = data
        self.performSegue(withIdentifier: "unwindToIssue", sender: self)
    }
}
