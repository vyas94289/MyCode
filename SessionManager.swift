//
//  SessionManager.swift
//  Populaw
//
//  Created by Gaurang on 09/09/21.
//

import Foundation

class SessionManager {
    static let shared = SessionManager()

    @UserDefault("ud_userId", defaultValue: nil)
    var userId: String?

    @UserDefault("ud_token", defaultValue: "")
    var apiToken: String

    @UserDefault("ud_user_type", defaultValue: nil)
    var userType: Int?

    var isLoggedIn: Bool {
        return !apiToken.isEmpty
    }

    /*func doLogin(info: UserProfile) {

    }*/

    func clear() {
        let defaults = UserDefaults.standard
        let dictionary = defaults.dictionaryRepresentation()
        dictionary.keys.forEach { key in
            defaults.removeObject(forKey: key)
        }
    }


    func logout() {
        clear()
        AppDelegate.current.setRootViewController()
    }


}

@propertyWrapper
struct UserDefault<T> {
    private let key: String
    private let defaultValue: T
    private let userDefaults: UserDefaults

    init(_ key: String, defaultValue: T, userDefaults: UserDefaults = .standard) {
        self.key = key
        self.defaultValue = defaultValue
        self.userDefaults = userDefaults
    }

    var wrappedValue: T {
        get {
            guard let value = userDefaults.object(forKey: key) else {
                return defaultValue
            }

            return value as? T ?? defaultValue
        }
        set {
            if let value = newValue as? OptionalProtocol, value.isNil() {
                userDefaults.removeObject(forKey: key)
            } else {
                userDefaults.set(newValue, forKey: key)
            }
        }
    }
}

private protocol OptionalProtocol {
    func isNil() -> Bool
}

extension Optional: OptionalProtocol {
    func isNil() -> Bool {
        return self == nil
    }
}
