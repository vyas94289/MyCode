//
//  UnderlineButton.swift
//  Populaw
//
//  Created by Gaurang on 14/09/21.
//

import UIKit

class UnderlineButton: UIButton {

    @IBInspectable var smallStyle: Bool = false

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
        titleLabel?.font = smallStyle ? FontBook.extraLight.font(ofSize: 15) : FontBook.bold.font(ofSize: 16)
    }

    func setViews() {
        setTitleColor(.themePrimary, for: .normal)
        backgroundColor = .clear
        guard let text = self.titleLabel?.text else { return }
        let fullRange = NSRange(location: 0, length: text.count)
        let attributedString = NSMutableAttributedString(string: text)

        attributedString.addAttribute(NSAttributedString.Key.underlineColor, value: self.titleColor(for: .normal)!, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.foregroundColor, value: self.titleColor(for: .normal)!, range: fullRange)
        attributedString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: fullRange)
        self.setAttributedTitle(attributedString, for: .normal)
        setNeedsDisplay()
    }

}
