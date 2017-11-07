//
//  Model.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 4..
//  Copyright © 2017년 devming. All rights reserved.
//

import Foundation
import SwiftyJSON

struct Model {
    
}

extension Model {   // Issue에 대한 모델 정의
    struct Issue {
        let id: Int
        let number: Int
        let title: String
        let user: Model.User
        let comments: Int
        let body: String
        let createdAt: Date?
        let updatedAt: Date?
        let closedAt: Date?
        let state: State
        
        init(json: JSON) {
            id = json["id"].intValue
            number = json["number"].intValue
            title = json["title"].stringValue
            user = Model.User(json: json["user"])
            state = State(rawValue: json["state"].stringValue) ?? .open
            comments = json["comments"].intValue
            body = json["body"].stringValue
            
            let format = DateFormatter()
            format.dateFormat = "yyyy-MM-dd'T'HH:mm:ss'Z'"
            createdAt = format.date(from: json["created_at"].stringValue)
            updatedAt = format.date(from: json["updated_at"].stringValue)
            closedAt = format.date(from: json["closed_at"].stringValue)
        }
    }
    
}

extension Model.Issue {
    enum State: String {    // state로 넘어오는 값은 enum으로 정의
        case open
        case closed
    }
}

extension Model {   // user 객체의 정의
    struct User {
        let id: String
        let login: String       // username
        let avatarURL: URL?
        
        /// JSON이 넘어오면 바로 적용시킬 수 있게 init을 생성
        init(json: JSON) {
            id = json["id"].stringValue
            login = json["login"].stringValue
            avatarURL = URL(string: json["avatar_url"].stringValue)
        }
    }
}







