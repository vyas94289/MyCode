//
//  OTPViewController.swift
//  DPS
//
//  Created by Gaurang on 18/10/21.
//  Copyright © 2021 Mayur iMac. All rights reserved.
//

import UIKit
import SwiftyJSON

enum Direction { case left, right }

class OtpVC: BaseViewController {

    @IBOutlet weak var headerContainer: UIView!
    @IBOutlet var otpView: ThemeOtpView!
    @IBOutlet weak var timerLabel: ThemeLabel!
    @IBOutlet weak var resendButton: ThemeButton!
    @IBOutlet weak var nextButton: ThemePrimaryButton!

    var loginJson: JSON?
    private var otpTimer: Timer?
    var seconds: Int = 60

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupNavigation(.auth(title: "Verify your Account", contentView: headerContainer))
        otpView.textFieldArray.first?.becomeFirstResponder()
        if let json = loginJson {
            print(json)
        }
        updateTimer()
        startTimer()
    }

    private func startTimer() {
        seconds = 60
        otpTimer?.invalidate()
        otpTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(timerDidFire(_:)), userInfo: nil, repeats: true)

    }

    @objc func timerDidFire(_ timer: Timer) {
        seconds -= 1
        updateTimer()
    }

    private func updateTimer() {
        timerLabel.isHidden = seconds == 0
        resendButton.isHidden = seconds > 0
        if seconds == 0 {
            otpTimer?.invalidate()
            seconds = 60
        }
        timerLabel.text = String(format: "00:%02d", seconds)
    }

    @IBAction func resendTapped() {
        startTimer()
    }

    @IBAction func nextButtonTapped() {
        let otpString = otpView.textFieldArray.compactMap({$0.text}).joined(separator: "")
        guard let json = loginJson else {
            return
        }
        let model = LoginModel.init(fromJson: json)
        guard let loginModelDetails = model.loginData else {
            return
        }
        if otpString == model.otp {
            SessionManager.shared.isUserLoggedIn = true
            let vehicleList = VehicleListModel(fromJson: json)
            SessionManager.shared.xApiKey = loginModelDetails.xApiKey
            SingletonClass.sharedInstance.walletBalance = loginModelDetails.walletBalance
            SingletonClass.sharedInstance.BulkMilesBalance = loginModelDetails.BulkMilesBalance
            SessionManager.shared.userProfile = model
            SingletonClass.sharedInstance.loginData = loginModelDetails
            SessionManager.shared.carList = vehicleList
            if json.dictionary?["booking_info"] != nil {
                let info = BookingInfo(fromJson: json.dictionary?["booking_info"])
                SingletonClass.sharedInstance.bookingInfo = info
            }
            AppDelegate.current.setRootViewController()
        } else {
            AlertMessage.showMessageForError("Please enter valid OTP code")
        }
    }

    func webserviceForResendOTP() {
        var paramter = [String : AnyObject]()
        paramter["email"] = SingletonRegistration.sharedRegistration.Email as AnyObject
        paramter["mobile_no"] = SingletonRegistration.sharedRegistration.MobileNo as AnyObject
        startTimer()
        WebService.shared.requestMethod(api: .otp, httpMethod: .post, parameters: paramter){ json,status in
            UtilityClass.hideHUD()
            if status {
                AlertMessage.showMessageForSuccess(json["message"].stringValue)
                SingletonClass.sharedInstance.RegisterOTP = json["otp"].stringValue
            } else {
                AlertMessage.showMessageForError(json["message"].stringValue)
            }
        }
    }

}
