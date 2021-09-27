//
//  ChatSectionHeaderView.swift
//  Populaw
//
//  Created by Gaurang on 22/09/21.
//

import UIKit

class ChatSectionHeaderView: UIView {

    let contentView = UIView()
    let label = UILabel()
    var date: Date?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    init(date: Date?) {
        self.date = date
        super.init(frame: .zero)
        setViews()
    }

    func setViews() {
        var constraints: [NSLayoutConstraint] = []
        contentView.backgroundColor = .themeChatBackColor
        contentView.translatesAutoresizingMaskIntoConstraints = false
        addSubview(contentView)
        constraints.append(contentView.centerXAnchor.constraint(equalTo: centerXAnchor))
        constraints.append(contentView.centerYAnchor.constraint(equalTo: centerYAnchor))
        label.textColor = .black
        label.font = FontBook.regular.font(ofSize: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(label)
        constraints.append(label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12))
        constraints.append(label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12))
        constraints.append(label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6))
        constraints.append(label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6))
        NSLayoutConstraint.activate(constraints)
        setDate()
        layoutIfNeeded()
    }

    func setDate() {
        guard let date = self.date else {
            label.text = ""
            return
        }
        label.text = DateFormatHelper.fullDate.getDateString(from: date)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.layer.cornerRadius = contentView.frame.height / 2
        contentView.clipsToBounds = true
    }

}
