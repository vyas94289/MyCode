//
//  ThemeBoxPicker.swift
//  Populaw
//
//  Created by Gaurang on 17/09/21.
//
import UIKit

class ThemeBoxPicker: UIView {

    var items: [String] = []
    var icon: UIImage = UIImage()
    var title: String = ""
    var titleStack: UIStackView!
    var stackView: UIStackView!
    var pickerView: UIPickerView!
    var titleLabel: UILabel!
    var selectedIndex: Int = -1
    var onItemSelected: ((_ pos: Int) -> Void)?


    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
       // setViews()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        //setViews()
    }

    func setupView(title: String, icon: UIImage, items: [String]) {
        self.title = title
        self.items = items
        self.icon = icon
        stackView?.removeAllArrangedSubviews()
        stackView?.isLayoutMarginsRelativeArrangement = true
        setViews()
    }

    func setSelected(index: Int) {
        pickerView.selectRow(index, inComponent: 0, animated: false)
        self.onItemSelected?(index)
    }

    override func layoutSubviews() {
        super.layoutSubviews()
        layer.borderWidth = 1
        layer.borderColor = UIColor.themePrimary.withAlphaComponent(0.3).cgColor
        layer.cornerRadius = 10
    }

    func setViews() {
        stackView = UIStackView()
        stackView.spacing = 16
        stackView?.alignment = .fill
        stackView?.axis = .vertical
        stackView?.translatesAutoresizingMaskIntoConstraints = false
        addSubview(stackView!)
        stackView?.setAllSideContraints(.zero)
        stackView?.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)
        stackView?.isLayoutMarginsRelativeArrangement = true

        titleStack = UIStackView()
        titleStack.spacing = 15
        titleStack.axis = .horizontal
        titleStack.alignment = .center

        let tapGesture = UILongPressGestureRecognizer(target: self, action: #selector(togglePicker(_:)))
        tapGesture.minimumPressDuration = 0
        titleStack.isUserInteractionEnabled = true
        titleStack.addGestureRecognizer(tapGesture)

        let iconView = UIImageView(image: icon)
        iconView.sizeToFit()
        iconView.setContentHuggingPriority(.required, for: .horizontal)
        titleStack.addArrangedSubview(iconView)

        titleLabel = UILabel()
        titleLabel.font = FontBook.extraLight.font(ofSize: 15)
        titleLabel.textColor = .themeDarkGrayLabel
        titleLabel.setContentHuggingPriority(.defaultLow, for: .horizontal)
        titleLabel.text = title
        titleStack.addArrangedSubview(titleLabel)

        let arrowView = UIImageView(image: AppImages.downArrow.image)
        arrowView.sizeToFit()
        arrowView.setContentHuggingPriority(.required, for: .horizontal)
        titleStack.addArrangedSubview(arrowView)

        stackView.addArrangedSubview(titleStack)

        pickerView = UIPickerView()
        pickerView.delegate = self
        pickerView.dataSource = self
        stackView.addArrangedSubview(pickerView)
        pickerView.translatesAutoresizingMaskIntoConstraints = false
        pickerView.heightAnchor.constraint(equalToConstant: 120).isActive = true
        pickerView.reloadAllComponents()
        hidePicker()
        layoutIfNeeded()

    }

    func showPicker() {
        pickerView.isHidden = false
    }

    func hidePicker() {
        pickerView.isHidden = true
    }

    func togglePicker() {
        pickerView.alpha = 0
        UIView.animate(withDuration: 0.3, animations: {
            self.pickerView.isHidden.toggle()
        }, completion: { _ in
            self.pickerView.alpha = 1
        })
    }


    @objc func togglePicker(_ gesture: UILongPressGestureRecognizer) {
        switch gesture.state {
        case .began:
            gesture.view?.alpha = 0.5
        case .ended:
            gesture.view?.alpha = 1
            togglePicker()
        default:
            break
        }
    }
}

extension ThemeBoxPicker: UIPickerViewDataSource, UIPickerViewDelegate {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        items.count
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        titleLabel.text = items[row]
        onItemSelected?(row)
    }
}
