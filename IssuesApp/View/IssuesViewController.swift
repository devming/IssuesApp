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
    var datasource: [Model.Issue] = []
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension IssuesViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.register(UINib(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
        load()
    }
    
    func load() {
        App.api.repoIssues(owner: owner, repo: repo, page: 1, handler: { [weak self] (response: DataResponse<[Model.Issue]>) in
            guard let `self` = self else { return }
            switch response.result {
            case .success(let items):
                print("issues: \(items)")
                self.dataLoaded(items: items)   // issue 값들 가져온거 datasource에 넣고, 컬렉션 뷰 새로고침
            case .failure:
                print("fail to load issues...")
                break
            }
        })
    }
    
    func dataLoaded(items: [Model.Issue]) {
        datasource = items
        collectionView.reloadData()
    }
}

extension IssuesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return datasource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else {
            return UICollectionViewCell()
        }
        let item = datasource[indexPath.item]
        cell.update(data: item)
        return cell
    }
}
