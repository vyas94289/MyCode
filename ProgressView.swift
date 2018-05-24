//
//  ProgressView.swift
//  MyHelp
//
//  Created by Dhaval Patel on 7/21/17.
//  Copyright © 2017 dasinfomedia. All rights reserved.
//

import Foundation
import UIKit

open class ProgressView{
    open class var shared:ProgressView{
        struct Static {
            static let instance: ProgressView = ProgressView()
        }
        return Static.instance
    }
    var containerView = progressView(frame: CGRect.zero)
    open var text:String = Const.loading{
        didSet{
            containerView.label.text = text
        }
    }
    open func showProgressView(_ view: UIView) {
        view.layoutIfNeeded()
        let frame = view.frame.size
        containerView.progress.isHidden = false
        containerView.image.isHidden = true
        text = Const.Loading
        containerView.label.text = text
        containerView.frame = CGRect(x: 0, y: 0, width: frame.width, height: frame.height)
       
        containerView.backgroundColor = UIColor.black.withAlphaComponent(0.3)
        containerView.layoutIfNeeded()
        view.addSubview(containerView)
       
        containerView.progress.startAnimating()
    }
    open func hideProgressViewWithSuccess(afterDelay:Int,text:String,completion:@escaping ()->Void){
        self.text = text
        self.containerView.image.isHidden = false
        self.containerView.progress.isHidden = true
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(afterDelay)) {
            self.hideProgressView()
            completion()
        }
    }
    open func hideProgressView() {
        containerView.progress.stopAnimating()
        containerView.removeFromSuperview()
    }
}
class progressView:UIView{
    var progress = UIActivityIndicatorView()
    var image = UIImageView()
    var label = UILabel()
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    private func setupView(){
        let container = UIVisualEffectView()
        addSubview(container)
        let content = container.contentView
        container.translatesAutoresizingMaskIntoConstraints = false

        container.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        container.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        content.backgroundColor = UIColor.blackClr.withAlphaComponent(0.8)
        container.cornerRadius = 4.0
        
        content.addSubview(progress)
        progress.translatesAutoresizingMaskIntoConstraints = false
        progress.activityIndicatorViewStyle = .whiteLarge
        progress.topAnchor.constraint(equalTo: content.topAnchor, constant: 12.0).isActive = true
        progress.centerXAnchor.constraint(equalTo: content.centerXAnchor).isActive = true
        
        content.addSubview(image)
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(named: "success")
        image.centerXAnchor.constraint(equalTo: progress.centerXAnchor).isActive = true
        image.centerYAnchor.constraint(equalTo: progress.centerYAnchor).isActive = true
        
        content.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.textAlignment = .center
        label.textColor = .white
        
        label.leadingAnchor.constraint(equalTo: content.leadingAnchor, constant: 12).isActive = true
        label.trailingAnchor.constraint(equalTo: content.trailingAnchor, constant: -12).isActive = true
        label.topAnchor.constraint(equalTo: progress.bottomAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: content.bottomAnchor, constant: -12).isActive = true
        label.widthAnchor.constraint(greaterThanOrEqualToConstant: 80).isActive = true
    }
}

