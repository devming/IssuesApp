//
//  IssueCell.swift
//  IssuesApp
//
//  Created by Minki on 2017. 11. 11..
//  Copyright © 2017년 devming. All rights reserved.
//

import UIKit

class IssueCell: UICollectionViewCell {
    @IBOutlet weak var stateButton: UIButton!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var commentCountButton: UIButton!
}

extension IssueCell {
    static var cellFromNib: IssueCell {
        guard let cell = Bundle.main.loadNibNamed("IssueCell", owner: nil, options: nil)?.first as? IssueCell else {
            return IssueCell()
        }
        return cell
    }
    
    func update(data issue: Model.Issue) {
        titleLabel.text = issue.title
        contentLabel.text = issue.body
        let createdAt = issue.createdAt?.string(dateFormat: "dd MMM yyyy") ?? "-"
        contentLabel.text = "#\(issue.number) \(issue.state.rawValue) on \(createdAt) by \(issue.user.login)"
        commentCountButton.setTitle("\(issue.comments)", for: .normal)
        stateButton.isSelected = issue.state == .closed
        let commentCountHidden: Bool = issue.comments == 0
        commentCountButton.isHidden = commentCountHidden
    }
}

extension Date {
    func string(dateFormat: String, locale: String = "en-US") -> String {
        let format = DateFormatter()
        format.dateFormat = dateFormat
        format.locale = Locale(identifier: locale)
        return format.string(from: self)
    }
}
