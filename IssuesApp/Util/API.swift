//
//  API.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
import OAuthSwift

protocol API {
    func getToken(handler: @escaping (() -> Void))
    func tokenRefresh(handler: @escaping (() -> Void))
}

struct GitHubAPI: API {     // API를 구현하는 구조체
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
    
}
