extension String {
    func toCurrencyString() -> String {
        guard let myDouble = Double(self) else {
            return ""
        }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.usesGroupingSeparator = true
        currencyFormatter.numberStyle = .currency
        currencyFormatter.locale = Locale(identifier: "en_US")
        let priceString = currencyFormatter.string(from: NSNumber(value: myDouble))!
        return priceString
    }

    var nsRange : NSRange {
        return NSRange(self.startIndex..., in: self)
    }

    func nsRange(of string: String) -> NSRange {
        return (self as NSString).range(of: string)
    }

    var trimmed: String {
        self.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    func toTimeFormate() -> String? {
        guard let minutes = Int(self) else {
            return nil
        }
        if minutes < 60 {
            return "\(minutes) Min"
        } else {
            let hr = minutes / 60
            let restMinutes = minutes % 60
            return "\(hr)Hr \(restMinutes)Min"
        }
    }
}

// =====================================
if let fullString = info.descriptionField, let underLineString = info.referenceId {
            let fullRange = fullString.nsRange
            let underLineStringRange = fullString.nsRange(of: underLineString)
            let mutableAttrStr = NSMutableAttributedString(string: fullString)
            mutableAttrStr.addAttributes([.font: FontBook.semibold.font(ofSize: 14),
                                          .foregroundColor: UIColor.themeBlack], range: fullRange)
            mutableAttrStr.addAttribute(.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: underLineStringRange)
            titleLabel.attributedText = mutableAttrStr
        }
