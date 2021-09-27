//
//  ThemeCheckmarks.swift
//  Populaw
//
//  Created by Gaurang on 17/09/21.
//

import Foundation
import UIKit

class ThemeCheckmarks: UIView {
    var buttons: [UIButton] = []
    var stackView: UIStackView?
    var selectedIndexes: [Int] = []
    var onItemSelected: ((_ index: [Int]) -> Void)?
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

    func setupView(items: [String], leadingPadding: CGFloat = 0, axis: NSLayoutConstraint.Axis = .vertical) {
        stackView?.removeAllArrangedSubviews()
        stackView?.axis = axis
        stackView?.layoutMargins = UIEdgeInsets(top: 0, left: leadingPadding, bottom: 0, right: 0)
        stackView?.isLayoutMarginsRelativeArrangement = true
        self.buttons = []
        stackView?.spacing = 15
        selectedIcon = AppImages.checked.image
        unselectedIcon  = AppImages.unchecked.image
        let font: UIFont = FontBook.extraLight.font(ofSize: 15)
        var counter: Int = 0
        for item in items {
            let button = UIButton(type: .custom)
            button.contentHorizontalAlignment = .leading
            button.setImage(unselectedIcon, for: .normal)
            button.setTitle(item, for: .normal)
            button.titleLabel?.font = font
            button.setTitleColor(color, for: .normal)
            button.titleEdgeInsets.left = 10
            button.tag = counter
            button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside )
            stackView?.addArrangedSubview(button)
            self.buttons.append(button)
            counter += 1
        }
        layoutIfNeeded()
    }

    func deselectAll() {
        self.selectedIndexes.forEach { index in
            setSelected(index: index)
        }
        self.selectedIndexes = []
    }

    func setSelected(index: Int) {
        let selected = !selectedIndexes.contains(index)
        let color = selected ? selectedColor : color
        let icon  = selected ? selectedIcon : unselectedIcon
        let button = self.buttons[index]
        button.setTitleColor(color, for: .normal)
        button.setImage(icon, for: .normal)
        selectedIndexes.removeAll(where: {$0 == index})
        if selected {
            selectedIndexes.append(index)
        }
        self.onItemSelected?(selectedIndexes)
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
