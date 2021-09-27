//
//  ThemeOptionMenuView.swift
//  Populaw
//
//  Created by Gaurang on 20/09/21.
//

import Foundation
import UIKit

class ThemeOptionMenuAction {
    let title: String
    let style: UIAlertAction.Style
    let completionHandler: ((ThemeOptionMenuAction) -> Swift.Void)

    init(title: String, style: UIAlertAction.Style, completionHandler: @escaping ((ThemeOptionMenuAction) -> Swift.Void)) {
        self.title = title
        self.style = style
        self.completionHandler = completionHandler
    }

}

class ThemeOptionMenuView: UIView {
    private var contentView: UIView?
    private var shadowLayer: CAShapeLayer!
    private var actions: [ThemeOptionMenuAction] = []
    var stackView: UIStackView?
    var onItemSelected: ((_ index: [Int]) -> Void)?
    private let selectedColor = UIColor.themePrimary
    private let color = UIColor.black
    private var selectedIcon: UIImage?
    private var unselectedIcon: UIImage?
    let font: UIFont = FontBook.bold.font(ofSize: 16)
    private let buttonHeight: CGFloat = 38
    private let rightPadding: CGFloat = 12

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        setViews()
    }

    func setViews() {
        stackView = UIStackView()
        stackView?.distribution = .fillProportionally
        stackView?.alignment = .fill
        stackView?.axis = .vertical
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView!)
        stackView?.setAllSideContraints(.zero)
        self.layer.cornerRadius = 10

    }

    override func layoutSubviews() {
        super.layoutSubviews()
        if shadowLayer != nil {
            shadowLayer.removeFromSuperlayer()
        }
        shadowLayer = CAShapeLayer()
        shadowLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 10).cgPath
        shadowLayer.fillColor = UIColor.white.cgColor
        shadowLayer.shadowColor = UIColor.lightGray.cgColor
        shadowLayer.shadowPath = shadowLayer.path
        shadowLayer.shadowOffset = CGSize(width: 0, height: 2)
        shadowLayer.shadowOpacity = 0.7
        shadowLayer.shadowRadius = 2
        layer.insertSublayer(shadowLayer, at: 0)
    }

    func addAction(_ action: ThemeOptionMenuAction) {
        let needSeparator: Bool = actions.count > 0
        let tag = actions.count
        self.actions.append(action)
        if needSeparator {
            let seperator = UIView()
            seperator.frame.size.height = 1
            seperator.backgroundColor = .themeSeperator
            stackView?.addArrangedSubview(seperator)
            seperator.translatesAutoresizingMaskIntoConstraints = false
            seperator.heightAnchor.constraint(equalToConstant: 1).isActive = true
        }
        let button = UIButton(type: .system)
        button.titleEdgeInsets = .init(top: 12, left: 8, bottom: 12, right: 8)
        button.contentHorizontalAlignment = .leading
        button.tag = tag
        button.setTitle(action.title, for: .normal)
        button.setTitleColor(action.style == .destructive ? .red : .black, for: .normal)
        button.titleLabel?.font = font
        stackView?.addArrangedSubview(button)
        button.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

    }

    @objc private func buttonTapped(_ sender: UIButton) {
        let action = actions[sender.tag]
        action.completionHandler(action)
        self.hide()
    }

    func presentOn(view: UIView, anchorView: UIView) {
        contentView = UIView(frame: view.bounds)
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(hide))
        contentView!.addGestureRecognizer(tapGesture)
        contentView!.isUserInteractionEnabled = true
        view.addSubview(contentView!)
        view.addSubview(self)

        let yAxis = anchorView.frame.origin.y + 12 + anchorView.frame.height
        let width: CGFloat = 125
        let height: CGFloat = (buttonHeight * CGFloat(actions.count)) + (CGFloat(actions.count) - 1)

        let xAxis = anchorView.frame.origin.x - width / 2
        let xInFull = view.frame.width - (width + rightPadding)

        frame = CGRect(x: min(xAxis, xInFull), y: yAxis, width: width, height: height)

        self.transform = .init(scaleX: 0, y: 0)
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 3, options: .curveEaseInOut, animations: {
            self.transform = .identity
        })
    }

    @objc func hide() {
        self.contentView?.removeFromSuperview()
        self.removeFromSuperview()
    }

}
