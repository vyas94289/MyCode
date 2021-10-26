extension UIView {

    func fittingHeight() {
        self.translatesAutoresizingMaskIntoConstraints = false
        let width = self.frame.width
        let temporaryWidthConstraint = self.widthAnchor.constraint(equalToConstant: width)
        self.addConstraint(temporaryWidthConstraint)
        self.setNeedsLayout()
        self.layoutIfNeeded()
        let size = self.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
        self.frame.size.height = size.height
        self.removeConstraint(temporaryWidthConstraint)
        self.translatesAutoresizingMaskIntoConstraints = true
    }
}
