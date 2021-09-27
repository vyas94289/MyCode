//
//  GradientButton.swift
//  Populaw
//
//  Created by Gaurang on 09/09/21.
//

import UIKit

class ThemeGradientButton: UIButton {

    private var activityIndicator: UIActivityIndicatorView!
    private var originalButtonText: String?

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
        self.applyDiagonalGradient(colours: [.themeGradientPrimary, .themeGradientSecondary])
    }

    func setViews() {
        self.setTitleColor(.white, for: .normal)
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

// MARK: - Loader
extension ThemeGradientButton {

    func showLoading() {
        isEnabled = false
        originalButtonText = self.titleLabel?.text

        self.setTitle("", for: .normal)
        if (activityIndicator == nil) {
            activityIndicator = createActivityIndicator()
        }

        showSpinning()
    }

    func hideLoading() {
        isEnabled = true
        self.setTitle(originalButtonText, for: .normal)
        activityIndicator.stopAnimating()
    }

    private func createActivityIndicator() -> UIActivityIndicatorView {

        let activityIndicator = UIActivityIndicatorView(style: .whiteLarge)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = .white
        return activityIndicator
    }

    private func showSpinning() {
        activityIndicator.translatesAutoresizingMaskIntoConstraints = false
        self.addSubview(activityIndicator)
        centerActivityIndicatorInButton()
        activityIndicator.startAnimating()
    }

    private func centerActivityIndicatorInButton() {
        activityIndicator.setCenterToViewContraints()
    }
}
