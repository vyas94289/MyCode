//
//  UITableView.swift
//  UberX
//
//  Created by Dhaval Patel on 08/03/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
import UIKit
extension UITableView
{
    func setBlankFooter(){
        let view = UIView()
        view.backgroundColor = UIColor.clear
        view.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: 0)
        self.tableFooterView = view
    }
    func noRecords(_ msg:String = Const.NoRecords) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = msg
        noDataLabel.textColor = UIColor.blackClr
        noDataLabel.textAlignment = .center
        self.backgroundView = noDataLabel
    }
    func retry(msg:String,action: @escaping () -> ()) {
        self.reloadData()
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        let label = UILabel()
        label.text = msg
        label.textColor = UIColor.blackClr
        label.textAlignment = .center
        let button = BlockButton(type: .system)
        button.setTitle("Retry", for: .normal)
        button.tintColor = UIColor.blackClr
        button.addClosure({
            action()
        }, for: .touchUpInside)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        let backView = UIView(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        backView.addSubview(stackView)
        stackView.center = backView.center
        self.backgroundView = backView
    }
    
}
class BlockButton: UIButton {
    fileprivate var onAction: (() -> ())?
    func addClosure(_ closure: @escaping () -> (), for control: UIControlEvents) {
        self.addTarget(self, action: #selector(actionHandler), for: control)
        self.onAction = closure
    }
    @objc dynamic fileprivate func actionHandler() {
        onAction?()
    }
}
extension UICollectionView{
    func noRecords(_ msg:String = Const.NoRecords) {
        let noDataLabel: UILabel = UILabel(frame: CGRect(x: 0, y: 0, width: self.bounds.size.width, height: self.bounds.size.height))
        noDataLabel.text = msg
        noDataLabel.textColor = UIColor.blackClr
        noDataLabel.textAlignment = .center
        self.backgroundView = noDataLabel
    }
    func retry(msg:String,action: @escaping () -> ()) {
        self.reloadData()
        let stackView = UIStackView(frame: CGRect(x: 0, y: 0, width: 200, height: 60))
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        let label = UILabel()
        label.text = msg
        label.textColor = UIColor.blackClr
        label.textAlignment = .center
        let button = BlockButton(type: .system)
        button.setTitle("retry".localized, for: .normal)
        button.tintColor = UIColor.blackClr
        button.addClosure({
            action()
        }, for: .touchUpInside)
        button.titleLabel?.lineBreakMode = .byWordWrapping
        button.titleLabel?.textAlignment = .center
        stackView.addArrangedSubview(label)
        stackView.addArrangedSubview(button)
        let backView = UIView(frame:CGRect(x: 0, y: 0, width: self.bounds.width, height: self.bounds.height))
        backView.addSubview(stackView)
        stackView.center = backView.center
        self.backgroundView = backView
    }
}
