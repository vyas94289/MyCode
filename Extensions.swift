//
//  Extensions.swift
//  YouRide
//
//  Created by Dhaval Patel on 11/7/17.
//  Copyright © 2017 dasinfomedia. All rights reserved.
//

import Foundation
import UIKit
import Kingfisher
//MARK: - Colors
extension UIColor {
   
    public class var blackClr : UIColor{
        return UIColor(named: "BlackClr")!
    }
    public class var grayClr : UIColor{
        return UIColor(named: "GrayClr")!
    }
    public class var GrayDarkClr : UIColor{
        return UIColor(named: "GrayDarkClr")!
    }
    public class var GrayLightClr : UIColor{
        return UIColor(named: "GrayLightClr")!
    }
    public class var GrayXLightClr : UIColor{
        return UIColor(named: "GrayXXXLight")!
    }
    public class var separatorClr :UIColor{
        return UIColor(red: 0.783922, green: 0.780392, blue: 0.8, alpha: 1)
    }
}


//MARK: - Refresh controll
extension UIRefreshControl {
    func refreshManually() {
        if let scrollView = superview as? UIScrollView {
            scrollView.setContentOffset(CGPoint(x: 0, y: scrollView.contentOffset.y - frame.height), animated: false)
        }
        beginRefreshing()
        sendActions(for: .valueChanged)
    }
}

extension String {
    var localized: String {
        return NSLocalizedString(self, comment: "")
    }
}

//MARK: Image
extension UIImageView{
    func setImageWith(url:String?){
        if let str = url,let url = URL(string: str){
            self.kf.setImage(with: url, placeholder:#imageLiteral(resourceName: "placeholder"))
        }
    }
    
}
//MARK: - Font
extension UIFont{
    public class func regular(size:CGFloat) -> UIFont{
        return UIFont.systemFont(ofSize:size)
        //return UIFont(name: Const.regularFont, size: size)!
    }
    public class func semibold(size:CGFloat) -> UIFont {
        return UIFont.systemFont(ofSize: size, weight: .semibold)
       // return UIFont(name: Const.boldFont, size: size)!
    }
}

//MARK : DateFormatter
extension DateFormatter{
    static let format_ddMMyyyy: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy" //"16/04/2018"
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        // formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
    static let format_ddMMyyyyHHmmss: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss" //2018-04-17 16:01:10
        //formatter.timeZone = TimeZone(secondsFromGMT: 0)
        // formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}


///
/////
///
//
