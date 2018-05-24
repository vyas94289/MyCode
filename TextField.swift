//
//  TextField.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 11/04/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import UIKit
@IBDesignable
class TextField : UITextField {
    override var tintColor: UIColor! {
        didSet {
            setNeedsDisplay()
        }
    }
    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 50)
    }

    @IBInspectable var icon:UIImage?{
        didSet{
            setNeedsDisplay()
        }
    }
    
   
    
    override func draw(_ rect: CGRect) {
        self.setValue(UIColor(red: 0.608, green: 0.608, blue: 0.608, alpha: 1), forKeyPath: "_placeholderLabel.textColor")
        leftViewMode = .always
        let startingPoint   = CGPoint(x: rect.minX, y: rect.maxY)
        let endingPoint     = CGPoint(x: rect.maxX, y: rect.maxY)
        let path = UIBezierPath()
        path.move(to: startingPoint)
        path.addLine(to: endingPoint)
        path.lineWidth = 1.0
        UIColor(red: 0.290, green: 0.290, blue: 0.290, alpha: 1).setStroke()
        path.stroke()
        if let icon =  self.icon{
            let view = UIView(frame: CGRect(x: 0, y: 0, width: 30, height: rect.height))
            let imageView = UIImageView(image: icon)
            imageView.contentMode = .center
            imageView.frame = CGRect(x: 0, y: 0, width: icon.size.width, height: rect.height)
            view.addSubview(imageView)
            self.leftView = view
        }
        setNeedsDisplay()
    }
}
