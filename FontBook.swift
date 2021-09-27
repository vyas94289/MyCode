//
//  AppTheme_FontColor.swift
//  Danfo_Rider
//
//  Created by Hiral Jotaniya on 15/03/21.
//


import Foundation
import UIKit

enum FontSize : CGFloat {
    
    case size8 = 8.0
    case size10 = 10.0
    case size12 = 12.0
    case size13 = 13.0
    case size14 = 14.0
    case size15 = 15.0
    case size16 = 16.0
    case size17 = 17.0
    case size18 = 18.0
    case size19 = 19.0
    case size20 = 20.0
    case size22 = 22.0
    case size24 = 24.0
}

enum FontBook {
    
    case regular, Hairline, extraLight, thin, light, semibold, bold,
         extraBold, ultra, black, blackItalic, ultraItalic, regularItalic,
         hairlineItalic, thinItalic, lightitalic, SemiBoldItalic, extraBoldItalic
    
    func font(ofSize fontSize: CGFloat) -> UIFont {
        switch self{
        case .regular:
            return UIFont(name: "ZonaPro-Regular", size: fontSize)!
        case .Hairline:
            return UIFont(name: "ZonaPro-Hairline", size: fontSize)!
        case .extraLight:
            return UIFont(name: "ZonaPro-ExtraLight", size: fontSize)!
        case .thin:
            return UIFont(name: "ZonaPro-Thin", size: fontSize)!
        case .light:
            return UIFont(name: "ZonaPro-Light", size: fontSize)!
        case .semibold:
            return UIFont(name: "ZonaPro-SemiBold", size: fontSize)!
        case .bold:
            return UIFont(name: "ZonaPro-Bold", size: fontSize)!
        case .extraBold:
            return UIFont(name: "ZonaPro-ExtraBold", size: fontSize)!
        case .ultra:
            return UIFont(name: "ZonaPro-Ultra", size: fontSize)!
        case .black:
            return UIFont(name: "ZonaPro-Black", size: fontSize)!
        case .blackItalic:
            return UIFont(name: "ZonaPro-BlackItalic", size: fontSize)!
        case .ultraItalic:
            return UIFont(name: "ZonaPro-UltraItalic", size: fontSize)!
        case .regularItalic:
            return UIFont(name: "ZonaPro-RegularItalic", size: fontSize)!
        case .hairlineItalic:
            return UIFont(name: "ZonaPro-HairlineItalic", size: fontSize)!
        case .thinItalic:
            return UIFont(name: "ZonaPro-ThinItalic", size: fontSize)!
        case .lightitalic:
            return UIFont(name: "ZonaPro-LightItalic", size: fontSize)!
        case .SemiBoldItalic:
            return UIFont(name: "ZonaPro-SemiBoldItalic", size: fontSize)!
        case .extraBoldItalic:
            return UIFont(name: "ZonaPro-ExtraBoldItalic", size: fontSize)!
        }
    }
}

extension UIFont {

    static var themeNavigationTitle: UIFont {
        FontBook.bold.font(ofSize: 26)
    }

    static var themeGradientButtonTitle: UIFont {
        FontBook.bold.font(ofSize: 18)
    }

}

