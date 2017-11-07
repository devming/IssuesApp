//
//  API.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
import OAuthSwift
import Alamofire
import SwiftyJSON

protocol API {
    typealias IssueResponseHandler = (DataResponse<[Model.Issue]>) -> Void
    func getToken(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping IssueResponseHandler)
}

struct GitHubAPI: API {
    // API를 구현하는 구조체
    // 2. oauth 객체 만들기
    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "71d2d6ff656986e1cba2",                                // GitHub에서 OAuth 생성한 곳에서 복붙
        consumerSecret: "707bdab8f62b50e7e1b5580291740ec3fc2b39ae",         // GitHub에서 OAuth 생성한 곳에서 복붙
        authorizeUrl: "https://github.com/login/oauth/authorize",           // 걍 입력
        accessTokenUrl: "https://github.com/login/oauth/access_token",     // 걍 입력
        responseType: "code")
    
    func getToken(handler: @escaping (() -> Void)) {
        oauth.authorize(
            withCallbackURL: "issuesapp://oauth-callback/github",
            scope: "user,repo",
            state: "state",
            success: { (credential, _, _) in
                let token = credential.oauthToken
                let refreshToken = credential.oauthRefreshToken
                print("token: \(token)")
                GlobalState.instance.token = token  // 싱글턴 토큰에 받아온 토큰 저장
                GlobalState.instance.refreshToken = refreshToken
                handler() // 결과가 나오면 handler를 실행해야한다.
        },
            failure: { error in
                print(error.localizedDescription)
        }) // withcallbackurl로 시작하는 첫번째 메소드 - 여기까지하면 사파리에서 로그인하라고 뜰거임. -> AppDelegate로 가서 맨 밑에 메소드 하나 추가할거임
    }
    
    func tokenRefresh(handler: @escaping (() -> Void)) {
        guard let refreshToken = GlobalState.instance.refreshToken else { return }
        oauth.renewAccessToken(withRefreshToken: refreshToken, success: { (credential, _, _) in
            let token = credential.oauthToken
            let refreshToken = credential.oauthRefreshToken
            print("token: \(token)")
            GlobalState.instance.token = token  // 싱글턴 토큰에 받아온 토큰 저장
            GlobalState.instance.refreshToken = refreshToken
            handler()
        }, failure: { error in
            print(error.localizedDescription)
        })
    }
    
    func repoIssues(owner: String, repo: String, page: Int, handler: @escaping API.IssueResponseHandler) {
        let parameters: Parameters = ["page": page, "state": "all"]
        GitHubRouter.manager.request(GitHubRouter.repoIssues(owner: owner, repo: repo, parameters: parameters)).responseSwiftyJSON { (dataResponse: DataResponse<JSON>) in
            
            let result = dataResponse.map({ (json: JSON) -> [Model.Issue] in
                return json.arrayValue.map {
                    Model.Issue(json: $0)
                }
            })
            
            handler(result)
        }
    }
}

enum GitHubRouter {
    case repoIssues(owner: String, repo: String, parameters: Parameters)
}

extension GitHubRouter: URLRequestConvertible {
    static let baseURLString: String = "https://api.github.com"
    static let manager: Alamofire.SessionManager = {    // alamofire의 config설정하고, 설정한 config를 manager에 담아서 변수로 사용한다.
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.timeoutIntervalForResource = 10
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }()
    
    var method: HTTPMethod {
        switch self {
        case .repoIssues:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case let .repoIssues(owner, repo, _):
            return "/repos/\(owner)/\(repo)/issues"
        }
    }
    
    func asURLRequest() throws -> URLRequest {
        let url = try GitHubRouter.baseURLString.asURL()    // base url 주소
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))  // url 뒤에
        urlRequest.httpMethod = method.rawValue
        if let token = GlobalState.instance.token, !token.isEmpty {
            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")
        }
        
        switch self {
        case let .repoIssues(_, _, parameters):
            urlRequest = try URLEncoding.default.encode(urlRequest, with: parameters)
        }
        
        return urlRequest
    }
    
}


















