//
//  UIViewContoller.swift
//  UberX
//
//  Created by Dhaval Patel on 08/03/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
import UIKit
extension UIViewController
{
    func setBackBarItems(){
        
        let closeButton = UIButton(type: .system)
        closeButton.frame = CGRect(x: 0, y: 0, width: 26, height: 44)
        closeButton.setImage(#imageLiteral(resourceName: "back_arrow_25px"), for: .normal)
        closeButton.addTarget(self, action: #selector(self.back(_:)), for: .touchUpInside)
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: closeButton)
    }
    @objc func back(_ sender:AnyObject){
        self.navigationController?.popViewController(animated: true)
    }
    func simpleAlertShow(title:String?,message:String?){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Const.ok, style: .cancel))
        self.present(alert, animated: true)
    }
    func simpleAlertShow(title:String?,message:String?,click:@escaping ()->()){
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Const.ok, style: .default, handler: { (_) in
            click()
        }))
        self.present(alert, animated: true)
    }
    func simpleRetryCancelAlert(message:String,retry:@escaping ()->Void) {
        let alert = UIAlertController(title: "failure".localized, message: message, preferredStyle: .alert)
        let retry = UIAlertAction(title: Const.retry, style: .default, handler: { (_) in
            retry()
        })
        let cancel = UIAlertAction(title: Const.cancel, style: .cancel)
        alert.addAction(retry)
        alert.addAction(cancel)
        self.present(alert, animated: true)
    }
    func setSwipeRecognizer() {
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self as? UIGestureRecognizerDelegate
    }
    
    func setBarButtonItems(){
        let menu = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_menu"), style: .plain, target: self, action: #selector(menuButtonTapped))
        let search = UIBarButtonItem(image: #imageLiteral(resourceName: "ic_search"), style: .plain, target: self, action: #selector(searchButtonTapped))
        self.navigationItem.leftBarButtonItem = menu
        self.navigationItem.rightBarButtonItem = search
    }
    @objc func menuButtonTapped(){
        let mStoryboard = UIStoryboard(name: StoryboardId.main, bundle: nil)
        let viewController = mStoryboard.instantiateViewController(
            withIdentifier:SideMenuVC.sceneId) as! SideMenuVC
        //let vc = SideMenu.shared.viewController
        viewController.completionBlock = {(vc) in
            if let ctr = vc{
                viewController.dismiss(animated: false, completion: {
                    self.navigationController?.pushViewController(ctr, animated: true)
                })
            }else{
                viewController.dismiss(animated: false, completion: {
                    self.tabBarController?.selectedIndex = 3
                })
            }
            
        }
       // viewController.parentViewContoller = self
        self.presentFromLeft(viewController)
    }
    @objc func searchButtonTapped(){
       if let search = UIStoryboard(name: StoryboardId.main, bundle: nil).instantiateViewController(withIdentifier: SearchVC.sceneId) as? SearchVC{
        self.navigationController?.pushViewController(search, animated: true)
           /* search.parentViewContoller = self
            self.present(UINavigationController(rootViewController: search), animated: true)*/
        }
    }
    func presentFromLeft(_ viewControllerToPresent: UIViewController) {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromLeft
        self.view.window!.layer.add(transition, forKey: kCATransition)
        present(viewControllerToPresent, animated: false)
    }
    
    func dismissFromLeft() {
        let transition = CATransition()
        transition.duration = 0.25
        transition.type = kCATransitionPush
        transition.subtype = kCATransitionFromRight
        self.view.window!.layer.add(transition, forKey: kCATransition)
        dismiss(animated: false)
    }
    
    func resetNavigationAppearance(){
        self.navigationController?.navigationBar.setBackgroundImage(nil, for: .default)
        navigationController?.navigationBar.shadowImage = nil
        //navigationController?.navigationBar.prefersLargeTitles = false
    }
    
    func setTransparentNavigation() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
    }
   
}


