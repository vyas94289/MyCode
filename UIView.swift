//
//  UIView.swift
//  UberX
//
//  Created by Dhaval Patel on 08/03/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
import UIKit
extension UIView {
    func cornerRadius(_ radius:CGFloat = 4.0){
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
    }
    func circle(){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.bounds.width / 2.0
    }
    func circle(with color:UIColor,borderWith:CGFloat=0){
        self.clipsToBounds = true
        self.layer.cornerRadius = self.frame.width / 2.0
        self.layer.borderColor = color.cgColor
        if borderWith != 0{
            self.layer.borderWidth = borderWith
        }
    }
    @IBInspectable
    var cornerRadius: CGFloat{
        get {
            return layer.cornerRadius
        }
        set {
            layer.cornerRadius = newValue
            layer.masksToBounds = newValue > 0
        }
    }
    func roundCorners(_ corners: UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
}
