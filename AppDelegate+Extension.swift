//
//  AppDelegate+Extension.swift
//  yousic
//
//  Created by Gaurang Vyas on 29/05/20.
//  Copyright © 2020 Solution Analysts. All rights reserved.
//

import AVKit
import Photos
import UIKit

extension AppDelegate {
    static var topViewController: UIViewController? {
        let keyWindow = UIApplication.shared.windows.filter { $0.isKeyWindow }.first

        if var topController = keyWindow?.rootViewController {
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController
            }
            return topController
        }
        return nil
    }

    static func showAlert(title: String?, message: String?, actions: [UIAlertAction]? = nil) {
        let alertVC = UIAlertController(title: title, message: message, preferredStyle: .alert)
        if let array = actions {
            array.forEach { alertVC.addAction($0) }
        } else {
            alertVC.addAction(.init(title: StringConst.okString, style: .cancel))
        }
        AppDelegate.topViewController?.present(alertVC, animated: true)
    }

    static func hasCameraAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = AVCaptureDevice.authorizationStatus(for: AVMediaType.video)
        switch authStatus {
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video) { granted in
                DispatchQueue.main.sync {
                    result(granted)
                }
            }
        case .restricted:
            AppDelegate.showAlert(title: MessageString.cameraAccess, message: MessageString.cameraAccessMsg)
            result(false)
        case .denied:
            AppDelegate.showAlert(title: MessageString.cameraAccess, message: MessageString.cameraAccessMsg)
                result(false)

        case .authorized:
                 result(true)

        @unknown default:
                result(false)
        }
    }

    static func hasPhotoLibraryAccess( result: @escaping (_ access: Bool) -> Void) {
        let authStatus = PHPhotoLibrary.authorizationStatus()
        switch authStatus {
        case .notDetermined:
            PHPhotoLibrary.requestAuthorization { granted in
                DispatchQueue.main.async {
                    result(granted == .authorized)
                }
            }
        case .restricted, .denied:
            AppDelegate.showAlert(title: MessageString.photoAccess, message: MessageString.photoAccessMsg)
            DispatchQueue.main.async {
                result(false)
            }

        case .authorized:
            DispatchQueue.main.async {
                result(true)
            }
        default:
            DispatchQueue.main.async {
                result(true)
            }
        }
    }
}
