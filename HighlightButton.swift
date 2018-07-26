//
//  HighlightButton.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 11/04/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import UIKit

class HighlightButton: UIButton {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

    }
    override init(frame: CGRect) {
        super.init(frame: frame)
       
    }
    override func awakeFromNib() {
        self.backgroundColor = UIColor.blackClr
        self.setTitleColor(UIColor.white, for: .normal)
        self.clipsToBounds = true
        self.layer.cornerRadius = 4.0
        self.contentEdgeInsets = UIEdgeInsets(top: 12, left: 10, bottom: 12, right: 10)
        
    }
    
    override var isHighlighted: Bool {
        get {
            return super.isHighlighted
        }
        set {
            if newValue {
                backgroundColor = UIColor.blackClr.withAlphaComponent(0.8)
            }
            else {
                backgroundColor = UIColor.blackClr
            }
            super.isHighlighted = newValue
        }
    }
    
}

@IBDesignable
class Button: UIButton {
    @IBInspectable var mainColor:UIColor? = UIColor.blue{
        didSet{
            let flag = isHighlighted
            isHighlighted = flag
        }
    }
    override func draw(_ rect: CGRect) {
            self.clipsToBounds = true
            self.layer.cornerRadius = rect.height / 2
    }
    override var isHighlighted: Bool{
        didSet{
            self.backgroundColor = isHighlighted ? mainColor?.withAlphaComponent(0.6) : mainColor
        }
    }
}
