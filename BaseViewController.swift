//
//  BaseViewController.swift
//  MvvmExampleSwift5.0
//
//  Created by Bekir on 14.01.2020.
//  Copyright © 2020 Bekir. All rights reserved.
//

import UIKit

protocol BaseViewControllerProtocol {
    func bindViewModel()
    func setupUI()
}

public class BaseViewController: UIViewController {
    private var loadingView: UIView?
    private var errorView: UIView?

    public func showSpinner(onView: UIView) {
        removeError()
        let contentView = UIView()
        contentView.backgroundColor = .white
        let indicator = UIActivityIndicatorView.init(style: .medium)
        indicator.startAnimating()
        DispatchQueue.main.async {
            onView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.setAllSideContraints(.zero)
            contentView.addSubview(indicator)
            indicator.translatesAutoresizingMaskIntoConstraints = false
            indicator.setCenterToViewContraints()
        }
        loadingView = contentView
    }

    public func removeSpinner() {
        DispatchQueue.main.async {
            self.loadingView?.removeFromSuperview()
            self.loadingView = nil
        }
    }

    public func showError(onView: UIView, error: String) {
        removeSpinner()
        let contentView = UIView()
        contentView.backgroundColor = .white
        let errorLabel = UILabel()
        errorLabel.text = error
        DispatchQueue.main.async {
            onView.addSubview(contentView)
            contentView.translatesAutoresizingMaskIntoConstraints = false
            contentView.setAllSideContraints(.zero)
            contentView.addSubview(errorLabel)
            errorLabel.translatesAutoresizingMaskIntoConstraints = false
            errorLabel.textAlignment = .center
            errorLabel.numberOfLines = 0
            errorLabel.setAllSideContraints(.init(top: 16, left: 16, bottom: -16, right: -16))
        }
        errorView = contentView
    }

    public func removeError() {
        DispatchQueue.main.async {
            self.errorView?.removeFromSuperview()
            self.errorView = nil
        }
    }

}
