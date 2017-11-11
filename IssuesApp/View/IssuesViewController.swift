//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 10..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit
import Alamofire /// alamofire 설명 - http://rhammer.tistory.com/115

class IssuesViewController: ListViewController<IssueCell> {
    @IBOutlet override var collectionView: UICollectionView! {
        get {
            return collectionView_
        }
        set {
            collectionView_ = newValue
        }
    }
    
    @IBOutlet var collectionView_: UICollectionView!
    override func viewDidLoad() {
        api = App.api.repoIssues(owner: owner, repo: repo)
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    
    override func cellName() -> String  {
        return "IssueCell"
    }
    
}
