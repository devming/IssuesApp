//
//  IssuesViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 4..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit
import Alamofire

protocol DataSourceRefreshable: class {     // class에만 상속할 수 있는
    associatedtype Item
    var dataSource: [Item] { get set }
    var needRefreshDatasource : Bool { get set }
}

extension DataSourceRefreshable {
    func setNeedRefreshDataSource() {
        needRefreshDatasource = true
    }
    func refreshDataSourceIfNeeded() {
        if needRefreshDatasource {
            dataSource = []
            needRefreshDatasource = false
        }
    }
}

class IssuesViewController: UIViewController, DataSourceRefreshable {
    
    var needRefreshDatasource: Bool = false
    @IBOutlet weak var collectionView: UICollectionView!
    let owner: String = GlobalState.instance.owner
    let repo: String = GlobalState.instance.repo
    var dataSource: [Model.Issue] = []
    fileprivate let estimateCell: IssueCell = IssueCell.cellFromNib
    let refreshControl = UIRefreshControl()
    var page: Int = 1
    var canLoadMore: Bool = true
    var isLoading: Bool = false
    var loadMoreFooterView: LoadMoreFooterView // footerview를 메모리에서 들고 있다가 Done을 할것인지 말것인지에 대한 객체
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
//        App.api.repoIssues(owner: owner, repo: repo, page: 1) { (dataResponse) in
//            print(dataResponse.value)
//        }
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

}

extension IssuesViewController {

    func setup() {
        collectionView.dataSource = self
        collectionView.delegate = self
        
        // register하기 전에 cell을 준비해야됨
        collectionView.register(UINib(nibName: "IssueCell", bundle: nil), forCellWithReuseIdentifier: "IssueCell")
        
        // Pull to Refresh 관련 기능
        collectionView.refreshControl = refreshControl
        collectionView.alwaysBounceVertical = true
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
    }
    
    /// api call
    func load() {
        guard isLoading == false else { return }
        isLoading = true
        App.api.repoIssues(owner: owner, repo: repo, page: 1) { [weak self] (dataResponse: DataResponse<[Model.Issue]>) in
            guard let `self` = self else { return }
            switch dataResponse.result {
            case .success(let items):
                self.isLoading = false
                self.dataLoaded(items: items)
            case .failure:
                self.isLoading = false
                break
            }
        }
    }
    
    func dataLoaded(items: [Model.Issue]) {
        refreshDataSourceIfNeeded()
        refreshControl.endRefreshing()
        page += 1
        if items.isEmpty {
            canLoadMore = false
            loadMoreFooterView.loadDone()
        }
        dataSource.append(contentsOf: items)
        collectionView.reloadData() // collectionview를 리로드하면서 다시 그려줌
    }
    
    func refresh() {
        // refresh가 되었을 때,
        page = 1
        canLoadMore = true
        loadMoreFooterView.load()
        setNeedRefreshDataSource()
        load()
    }
    
    func loadMore(indexPath: IndexPath) {
        guard indexPath.item == dataSource.count - 1  // 마지막 셀
            && !isLoading && canLoadMore else { return }
        load()
    }
}

extension IssuesViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "IssueCell", for: indexPath) as? IssueCell else { return IssueCell() }
        let data = dataSource[indexPath.item]
        cell.update(data: data)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch kind {       // header로 올꺼냐 footer로 올꺼냐
        case UICollectionElementKindSectionHeader:
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        case UICollectionElementKindSectionFooter:
            let footer = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "LoadMoreFooterView", for: indexPath) as? LoadMoreFooterView ?? LoadMoreFooterView()
            return footer
        default:
            assert(false, "unexpected element kind")
            return UICollectionReusableView()
        }
    }
}

extension IssuesViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let data = dataSource[indexPath.item]
        estimateCell.update(data: data) // 가져온 데이터로 셀을 그린다.
        let targetSize = CGSize(width: collectionView.frame.width, height: 50)
        let estimatedSize = estimateCell.contentView.systemLayoutSizeFitting(targetSize, withHorizontalFittingPriority: UILayoutPriorityRequired, verticalFittingPriority: UILayoutPriorityDefaultLow)
        
        return estimatedSize
    }   // 계산한 셀의 크기를 반환
}

extension IssuesViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        loadMore(indexPath: indexPath)
    }
}
















