//
//  UIColor+Extension.swift
//  Populaw
//

import UIKit

protocol StoryboardIdentifiable {
    static var storyboardIdentifier: String { get }
}

extension StoryboardIdentifiable where Self: UIViewController {
    static var storyboardIdentifier: String {
        return String(describing: self)
    }
}

extension UIViewController: StoryboardIdentifiable { }

extension UIStoryboard {
    /// The uniform place where we state all the storyboard we have in our application

    enum Storyboard: String {
        case launch     = "LaunchScreen"
        case main       = "Main"
        case profile    = "Profile"
        case signIn     = "SignIn"
        case signUp     = "SignUp"
        case home       = "Home"
        case popups     = "Popups"
        case search     = "Search"
        case post       = "Post"
        case group      = "Groups"
        case notification = "Notification"
        case accountSetting = "AccountSetting"
        case chat       = "Chat"

        var filename: String {
            return rawValue
        }
        
        var instance: UIStoryboard {
            return UIStoryboard(storyboard: self)
        }
    }

    // MARK: - Convenience Initializers

    convenience init(storyboard: Storyboard) {
        self.init(name: storyboard.filename, bundle: nil)
    }

    // MARK: - Class Functions

    class func storyboard(_ storyboard: Storyboard) -> UIStoryboard {
        return UIStoryboard(name: storyboard.filename, bundle: nil)
    }

    // MARK: - View Controller Instantiation from Generics

    func instantiate<T: UIViewController>() -> T {
        guard let viewController = self.instantiateViewController(withIdentifier: T.storyboardIdentifier) as? T else {
            fatalError("Couldn't instantiate view controller with identifier \(T.storyboardIdentifier) ")
        }

        return viewController
    }
}


// usage
//let viewController: ArticleViewController = UIStoryboard(storyboard: .news).instantiateViewController()
