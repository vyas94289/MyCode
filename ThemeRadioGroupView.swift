//
//  ThemeRadioGroupView.swift
//  Populaw
//
//  Created by Gaurang on 15/09/21.
//

import UIKit

class ThemeRadioGroupView: UIView {
    var buttons: [UIButton] = []
    var stackView: UIStackView?
    var selectedIndex: Int = -1
    var onItemSelected: ((_ pos: Int) -> Void)?
    private let selectedColor = UIColor.themePrimary
    private let color = UIColor.black
    private var selectedIcon: UIImage?
    private var unselectedIcon: UIImage?

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setupView(items: [String], isSmallStyle: Bool, leadingPadding: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) {
        stackView?.removeAllArrangedSubviews()
        stackView?.axis = axis
        stackView?.layoutMargins = UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: 0)
        stackView?.isLayoutMarginsRelativeArrangement = true
        self.buttons = []
        stackView?.spacing = isSmallStyle ? 12 : 20
        selectedIcon = isSmallStyle ? AppImages.radioSelectedSmall.image : AppImages.radioSelected.image
        unselectedIcon  = isSmallStyle ? AppImages.radioUnselectedSmall.image : AppImages.radioUnselected.image
        let font: UIFont = FontBook.extraLight.font(ofSize: isSmallStyle ? 14 : 15)
        var counter: Int = 0
        for item in items {
            let button = UIButton(type: .custom)
            button.contentHorizontalAlignment = .leading
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = font
            button.titleEdgeInsets.left = 10
            button.tag = counter
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside )
            stackView?.addArrangedSubview(button)
            self.buttons.append(button)
            counter += 1
        }
        setSelected(index: selectedIndex)
        layoutIfNeeded()
    }

    func setSelected(index: Int) {
        for button in buttons {
            let color = button.tag == index ? selectedColor : color
            let icon  = button.tag == index ? selectedIcon : unselectedIcon
            button.setTitleColor(color, for: .normal)
            button.setImage(icon, for: .normal)
        }
        self.onItemSelected?(index)
    }

    override func layoutSubviews() {
        super.layoutSubviews()

    }

    func setViews() {
        stackView = UIStackView()
        stackView?.distribution = .fillEqually
        stackView?.alignment = .fill
        stackView?.axis = .vertical
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView!)
        stackView?.setAllSideContraints(.zero)
    }

    @objc private func buttonTapped(_ sender: UIButton) {
        setSelected(index: sender.tag)
    }


}

extension UIStackView {
    func removeAllArrangedSubviews() {
        for view in arrangedSubviews {
            view.removeFromSuperview()
        }
    }
}
