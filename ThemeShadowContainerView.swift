//
//  ThemeShadowContainerView.swift
//  DPS
//
//  Created by Gaurang on 04/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import Foundation
import UIKit

class ThemeShadowContainerView: UIView {

    private lazy var shadowLayer: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.fillColor = UIColor.white.cgColor
        layer.frame = bounds
        layer.shadowOffset = .zero
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowRadius = 5
        layer.shadowOpacity = 0.3
        layer.path = UIBezierPath(roundedRect: bounds, byRoundingCorners: .allCorners, cornerRadii: CGSize(width: 15, height: 15)).cgPath
        self.layer.insertSublayer(layer, at: 0)
        return layer
    }()


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        shadowLayer.frame = bounds
    }

    func setViews() {
        backgroundColor = .clear
    }

}
