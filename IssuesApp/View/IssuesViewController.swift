//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 10..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit
import Alamofire /// alamofire 설명 - http://rhammer.tistory.com/115

class IssuesViewController: UIViewController {
    
    let owner = GlobalState.instance.owner
    let repo = GlobalState.instance.repo
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension IssuesViewController {
    func setup() {
        load()
    }
    
    func load() {
        App.api.repoIssues(owner: owner, repo: repo, page: 1, handler: { (response: DataResponse<[Model.Issue]>) in
            switch response.result {
            case .success(let items):
                print("issues: \(items)")
            case .failure:
                print("fail to load issues...")
                break
            }
        })
    }
    
    func dataLoaded(items: [Model.Issue]) {
        
    }
}
