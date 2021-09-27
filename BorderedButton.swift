//
//  ThemeBorderedButton.swift
//  Populaw
//
//  Created by Gaurang on 09/09/21.
//

import UIKit

class ThemeBorderedButton: UIButton {
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
       setViews()
    }

    override open var intrinsicContentSize: CGSize {
        return CGSize(width: super.intrinsicContentSize.width, height: 58)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setViews()
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        titleLabel?.font = .themeGradientButtonTitle
        clipToCapsule()
    }

    func setViews() {
        setTitleColor(.themePrimary, for: .normal)
        backgroundColor = .clear
        setNeedsDisplay()
    }

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.2) {
                self.transform = self.isHighlighted ? .init(scaleX: 0.9, y: 0.9) : .identity
            }
        }
    }
}
