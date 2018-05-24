
import Foundation
import UIKit

class Const{
    //MARK: - Common Strings
    static let NoRecords = "NoRecords".localized
    static let networkError = "NetworkError".localized
    static let Alert = "Alert".localized
    static let ok = "ok".localized
    static let BlankNotAllowed = "BlankNotAllowed".localized
    static let wait = "Wait".localized
    static let loading = "loading".localized
    static let back = "back".localized
    static let cancel = "Cancel".localized
    static let wentWrong = "wentWrong".localized
    static let wentWrongRetry = "wentWrongRetry".localized
    static let Loading = "Loading".localized
    static let retry = "retry".localized
    static let failure = "failure".localized
    static let success = "success".localized
    static let error = "error".localized
    //MARK: - Font Name
    //static let boldFont = "Lato-Bold"
    //static let regularFont = "Lato-Regular"
    //MARK: - OnePx
    static let scale = UIScreen.main.scale
    static let onePx = 1/Const.scale
    
    static var isSimulator: Bool {
        return TARGET_OS_SIMULATOR != 0
    }
    
    //Set root vc in app delegate
    static let appDel = UIApplication.shared.delegate as! AppDelegate
    
    static func getPrice(special:String?,price:String?,separator:String = " ") -> NSAttributedString?{
        
        let priceColor = [NSAttributedStringKey.foregroundColor:UIColor.blackClr]
        let oldPriceColor = [NSAttributedStringKey.foregroundColor:UIColor.grayClr]
        
        if let specialPrice = special,
            let unwrappedPrice = price,
            specialPrice != "0"{
            
            let attributted = NSMutableAttributedString(string: unwrappedPrice)
            attributted.addAttributes(oldPriceColor, range: NSMakeRange(0, attributted.length))
            
            attributted.addAttribute(.strikethroughStyle, value: 2, range: NSMakeRange(0, attributted.length))
            
            attributted.append(NSAttributedString(string: separator+specialPrice, attributes: priceColor))
            return attributted
            
        }else if let unwrappedPrice = price{
            return NSAttributedString(string: unwrappedPrice, attributes: priceColor)
        }
        
        return nil
    }
}
class StoryboardId  {
    static let slider = "Slider"
    static let home = "Home"
    static let main = "Main"
    static let product = "Product"
    static let categories = "Categories"
    static let profile = "Profile"
}
