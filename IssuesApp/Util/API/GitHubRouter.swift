//
//  GitHubRouter.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 4..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
import Alamofire

enum GitHubRouter {
    case repoIssues(owner: String, repo: String, parameter: Parameters)
}

extension GitHubRouter: URLRequestConvertible {      // 이 객체는 URL Request가 될수있는 객체이다.
    
    static let baseURLString: String = "https://api.github.com"
    static let manager: Alamofire.SessionManager = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10 // seconds
        configuration.timeoutIntervalForResource = 10
        configuration.httpCookieStorage = HTTPCookieStorage.shared
        configuration.urlCache = URLCache(memoryCapacity: 0, diskCapacity: 0, diskPath: nil)// caching 못하게 설정할 것임
        let manager = Alamofire.SessionManager(configuration: configuration)
        return manager
    }() // 클로저 만들어서 바로 실행
    
    var method: HTTPMethod {     //api 메소드 지정
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
        let url = try GitHubRouter.baseURLString.asURL()
        
        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
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
//    func asURLRequest() throws -> URLRequest {
//        let url = try GitHubRouter.baseURLString.asURL()
//        var urlRequest = URLRequest(url: url.appendingPathComponent(path))
//        urlRequest.httpMethod = method.rawValue
//
//         // header에 토큰을 넣어줘야함
//        if let token = GlobalState.instance.token, !token.isEmpty {
//            urlRequest.setValue("token \(token)", forHTTPHeaderField: "Authorization")  //Authorization: token key 이름
//        }
//        switch self {
//        case let .repoIssues(_, _, paramater):
//            urlRequest = try URLEncoding.default.encode(urlRequest, with: paramater)
//
//        }
//
//        return urlRequest
//    }
  
    
}
