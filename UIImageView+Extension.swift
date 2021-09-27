//
//  UIImageView+Extension.swift
//  MVVMDemo
//
//  Created by Gaurang on 02/09/21.
//

import UIKit
import Kingfisher

extension UIImageView {
    // Download Image and Set into ImageView
    func setImage(imageURL: String?, placeholderImage: UIImage? =  nil, showIndicator: Bool = true) {
        if let imageURL = imageURL, let url = URL(string: imageURL) {
            self.image = nil
            if showIndicator {
                kf.indicatorType = .custom(indicator: ImageIndicator())
            }
            kf.setImage(with: url, placeholder: placeholderImage, options: [.transition(.fade(1))])
        } else {
            self.image = placeholderImage
        }
    }
}

struct ImageIndicator: Indicator {
    let view: UIView = UIView()
    let indicator = UIActivityIndicatorView(style: .medium)

    func startAnimatingView() {
        view.isHidden = false
        indicator.startAnimating()
    }
    func stopAnimatingView() {
        indicator.stopAnimating()
        view.isHidden = true
    }

    init() {
        indicator.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(indicator)
        view.backgroundColor = .black
        indicator.setCenterToViewContraints()
        indicator.heightAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.widthAnchor.constraint(equalToConstant: 20).isActive = true
        indicator.center = view.center
    }
}
