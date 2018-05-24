//
//  UserData.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 16/04/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
import UIKit
enum UserType:Int{
    case guest = 0
    case registered = 1
}
class UserData{
    static let kCustomerId = "ud_customer_id"
    static let kName = "ud_name"
    static let kProfilePic = "ud_profile_pic"
    static let kFirstTime = "ud_first_time"
    static let kSession = "ud_session"
    static let kLanguage = "ud_language"
    static let kLanguageCodeEnglish = "en-gb"
    static let kLanguageCodeFrench = "fr"
    static let kCurrency = "ud_currency"
    static let kUserType = "ud_user_type"
    static let kRewardPoints = "ud_reward_point"
    
    static let userDefaults = UserDefaults.standard
    
    static var session:String{
        get{
            return userDefaults.string(forKey: "kSession") ?? ""
        }set{
            userDefaults.set(newValue, forKey: "kSession")
        }
    }
    
    static let merchantId = "OS6WtQXjnUZvtnfWNLBG6ATiXLb351d3"
    
    static var userType:UserType?{
        get{
            let index = userDefaults.integer(forKey: kUserType)
            return UserType(rawValue: index)
        }
    }
    static var currencyCode:String?{
        get{
            return userDefaults.string(forKey: kCurrency)
        }set{
            userDefaults.set(newValue, forKey: kCurrency)
        }
    }
    static var language:String{
        get{
            return userDefaults.string(forKey: kLanguage) ?? kLanguageCodeEnglish
        }set{
            userDefaults.set(newValue, forKey: kLanguage)
        }
    }
    
    static var customerId:String?{
        get{
            if userDefaults.object(forKey: kCustomerId) != nil{
                return userDefaults.string(forKey: kCustomerId)
            }
            else{
                return nil
            }
        }
    }
    
    static var name:String?{
        get{
            if userDefaults.object(forKey: kName) != nil{
                return userDefaults.string(forKey: kName)
            }
            else{
                return nil
            }
        }
    }
    
    static var rewardPoint:String?{
        get{
            return userDefaults.string(forKey: kRewardPoints)
        }
        set{
            userDefaults.set(newValue, forKey: kRewardPoints)
        }
    }
    
    static var profilePic:URL?{
        get{
            return userDefaults.url(forKey: kProfilePic)
        }
    }
    
    static var isFirstTime:Bool{
        set{
            userDefaults.set(newValue, forKey: kFirstTime)
        }
        get{
            if userDefaults.object(forKey: kFirstTime) != nil{
                return userDefaults.bool(forKey: kFirstTime)
            }
          //  self.isFirstTime = false
            return true
        }
    }
    
    static func isLoggedIn()->Bool{
        return customerId != nil
    }
    
    public static func createSession(id:String,name:String,dp:URL?,
                                     userType:UserType)  {
        userDefaults.set(id, forKey: kCustomerId)
        userDefaults.set(name.capitalized, forKey: kName)
        userDefaults.set(dp, forKey: kProfilePic)
        userDefaults.set(userType.rawValue, forKey: kUserType)
        UserDefaults.standard.synchronize()
    }
    
    static func clean(){
        userDefaults.removeObject(forKey: kName)
        userDefaults.removeObject(forKey: kCustomerId)
        userDefaults.removeObject(forKey: kProfilePic)
        userDefaults.removeObject(forKey: kRewardPoints)
    
    }
    
    
    
    public static func getCurrencyString(for amount:NSNumber)->String?{
        let locale = Locale.availableIdentifiers.map { Locale(identifier: $0) }.first { $0.currencyCode == self.currencyCode }
        let currencyFormatter = NumberFormatter()
        currencyFormatter.currencyCode = locale?.currencyCode
        currencyFormatter.numberStyle = .currency
        return currencyFormatter.string(from:amount)
    }
    
    static func logout(vc:UIViewController){
        SideMenu.shared.profile = nil
        if let type = userType,type == .guest{
            UserData.clean()
            Const.appDel.setRoot()
            return
        }
        ProgressView.shared.showProgressView(vc.view)
        ProgressView.shared.text = "Logging out".localized
        DataRequest.post(url: URLs.logout, param: nil) { (response) in
            ProgressView.shared.hideProgressView()
            switch response{
            case .success(let data):
        
                guard let dictionary = try? JSONSerialization.jsonObject(with: data, options: .mutableLeaves) as? [String:Any] else {
                    vc.simpleAlertShow(title: Const.Alert, message:Const.wentWrong)
                    return
                }
                if dictionary?["success"] as? Int ?? 0 == 0{
                    let msg = (dictionary?["error"] as? NSArray)?.firstObject as? String ?? Const.wentWrong
                    vc.simpleAlertShow(title: Const.error, message: msg)
                    UserData.clean()
                    Const.appDel.setRoot()
                }else{
                    UserData.clean()
                    Const.appDel.setRoot()
                }
                break
            case .failure(_,let message):
                vc.simpleRetryCancelAlert(message: message, retry: {
                    logout(vc: vc)
                })
                break
            }
        }
    }
    
    static func currencyRequest(){
        DataRequest.get(url: URLs.settings) { (response) in
            switch response{
            case .success(let data):
                do{
                    let info = try JSONDecoder().decode(Settings.self, from: data)
                    if let currency = info.data?.currencies{
                        self.currencyCode = currency.first?.code
                    }
                }catch(let error){
                    print(error)
                }
                break
            case .failure(let error,_):
                print(error)
                break
            }
        }
    }
    
}
