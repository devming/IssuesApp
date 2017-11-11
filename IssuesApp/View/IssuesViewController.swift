//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 10..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit
import Alamofire /// alamofire 설명 - http://rhammer.tistory.com/115

protocol DatasourceRefreshable: class {
    associatedtype Item
    var datasource: [Item] { get set }
    var needRefreshDatasource: Bool { get set }
}

extension DatasourceRefreshable {
    func setNeedRefreshDatasource() {
        needRefreshDatasource = true
    }
    func refreshDataSourceIfNeeded() {
        if needRefreshDatasource {
            datasource = []
            needRefreshDatasource = false
        }
    }
}

class IssuesViewController: UIViewController, DatasourceRefreshable {
    var needRefreshDatasource: Bool = false
    
    fileprivate let estimateCell: IssueCell = IssueCell.cellFromNib
    @IBOutlet weak var collectionView: UICollectionView!
    lazy var owner: String = { return GlobalState.instance.owner }()
    lazy var repo: String  = { return GlobalState.instance.repo }()
    var datasource: [Model.Issue] = []
    let refreshControl = UIRefreshControl()
    var loadMoreCell: LoadMoreFooterView?
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var page: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setup()
    }
}

extension IssuesViewController {
    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(UINib(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        load()
        loadMoreCell?.load()
    }
    
    func load() {
        guard isLoading == false else { return }
        isLoading = true
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
        refreshDataSourceIfNeeded()
        
        page += 1
        if items.isEmpty {
            canLoadMore = false
            loadMoreCell?.loadDone()
        }
        
        refreshControl.endRefreshing()
        datasource = items
        collectionView.reloadData()
    }
    
    @objc func refresh() {
        page = 1
        canLoadMore = true
        loadMoreCell?.load()
        setNeedRefreshDatasource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard  indexPath.item == datasource.count - 1 && !isLoading && canLoadMore else { return }
        load()
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
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {
        case UICollectionElementKindSectionHeader:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            loadMoreCell = footerView
            return footerView
        default:
            assert(false, "Unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension IssuesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = datasource[indexPath.item]
        estimateCell.update(data: data)
        let targetSize = CGSize(width: collectionView.frame.size.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        return estimatedSize
    }
}

extension IssuesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
}
