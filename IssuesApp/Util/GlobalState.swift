//
//  GlobalState.swift
//  IssuesApp
//
//  Created by Minki on 2017. 10. 28..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
/// iOS의 UserDefault에 접근해서 토큰과 refresh 토큰과 최근에 방문했던 repo주소, 최근에 방문했던 repo를 목록으로도 저장할 것임
final class GlobalState {
    static let instance = GlobalState() // singleton객체 생성
    
    enum Constants: String {
        case tokenKey
        case refreshTokenKey
    }
    
    var token: String? { //computed prop.
        get {
            let token = UserDefaults.standard.string(forKey: Constants.tokenKey.rawValue)       // 무슨일 생겼을 때 찍어보려고 바로 리턴 안하심.
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.tokenKey.rawValue)        // Key를 통해서 값을 세팅
        }
    }   //GlobalState.instance.token와 같이 싱글턴 사용
    
    var refreshToken: String? { //computed prop.
        get {
            let token = UserDefaults.standard.string(forKey: Constants.refreshTokenKey.rawValue)
            return token
        }
        set {
            UserDefaults.standard.set(newValue, forKey: Constants.refreshTokenKey.rawValue)        // Key를 통해서 값을 세팅
        }
    }
}


