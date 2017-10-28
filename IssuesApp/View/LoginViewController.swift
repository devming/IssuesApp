//
//  LoginViewController.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit
import OAuthSwift   // 1. import

class LoginViewController: UIViewController {

    // 2. oauth 객체 만들기
    let oauth: OAuth2Swift = OAuth2Swift(
        consumerKey: "71d2d6ff656986e1cba2",                                // GitHub에서 OAuth 생성한 곳에서 복붙
        consumerSecret: "707bdab8f62b50e7e1b5580291740ec3fc2b39ae",         // GitHub에서 OAuth 생성한 곳에서 복붙
        authorizeUrl: "https://github.com/login/oauth/authorize",           // 걍 입력
        accessTokenUrl: "https://github.com/login/oauth/access_token",     // 걍 입력
        responseType: "code")
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func loginToGitHubButtonTapped(_ sender: UIButton) {
        oauth.authorize(withCallbackURL: "", scope: "", state: "", success: "", failure: "")
        oauth.authorize(
            withCallbackURL: "issuesapp://oauth-callback/github",
            scope: "user,repo",
            state: "state",
            success: { (credential, _, _) in
                let token = credential.oauthToken
                print("token: \(token)")
        },
            failure: {error in
                print(error)
        }) // withcallbackurl로 시작하는 첫번째 메소드 - 여기까지하면 사파리에서 로그인하라고 뜰거임. -> AppDelegate로 가서 맨 밑에 메소드 하나 추가할거임
        
    }
}
