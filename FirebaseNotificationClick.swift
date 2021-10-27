import UIKit
import Firebase
import FirebaseMessaging


extension AppDelegate {

    func configFirebase(_ app: UIApplication) {
        if let bundleFilePath = Bundle.main.path(forResource: Helper.googleServiceInfoFileName,
                                                 ofType: StringConst.plistFileExtension),
            let firebaseOptions = FirebaseOptions(contentsOfFile: bundleFilePath) {
            Messaging.messaging().delegate = self
            FirebaseApp.configure(options: firebaseOptions)
            registerForRemoteNotification(application: app)
        }
    }

    func registerForRemoteNotification(application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: {_, _ in })
        application.registerForRemoteNotifications()
    }

    // [START receive_message]
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        print(userInfo)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        print(userInfo)

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        let deviceTokenString = deviceToken.map { String(format: "%02x", $0) }.joined()
        print("deviceTokenString - ", deviceTokenString)
        Messaging.messaging().apnsToken = deviceToken
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("didFailToRegisterForRemoteNotificationsWithError - ", error.localizedDescription)
    }

    fileprivate func redirectNotificationWith(_ userInfo: [AnyHashable: Any]) {
        let info = PushNotification(dictionary: userInfo)
        if let type = info.type {
            self.notificationRedirectTo(type, postID: info.postId)
        }
    }

    func notificationRedirectTo(_ notificationType: NotificationType, postID: String? = nil) {
        if let tabBarVC = self.window?.rootViewController as? UITabBarController,
            let navigationController = tabBarVC.selectedViewController as? UINavigationController,
            UserData.shared.isLoggedIn {
            switch notificationType {
            case .newFollower:
                let followVC = FollowerViewController.getNewInstance(.followers, userId: UserData.shared.userId!)
                navigationController.pushViewController(followVC, animated: false)
            case .like, .mention, .comment:
                guard let postID = postID else {
                    return
                }
                PostDetailsViewController
                    .presentWithNavigationForSingleTrack(postId: postID,
                                                         parentVC: navigationController.visibleViewController!,
                                                         closeComplition: nil)

            case .message, .share:
                break
            }
        }
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {

    // Receive displayed notifications for iOS 10 devices.
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification,
                                withCompletionHandler completionHandler:
        @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([[.alert, .sound]])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                didReceive response: UNNotificationResponse,
                                withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        print(#function, userInfo)
        redirectNotificationWith(userInfo)
        NotificationConst.onNewNotificationReceive.postNotification()
        completionHandler()
    }
}

extension AppDelegate: MessagingDelegate {

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("Firebase registration token: \(String(describing: fcmToken))")
        registereDeviceToken()
        let dataDict: [String: String] = ["token": fcmToken ?? "" ]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)

    }
}
