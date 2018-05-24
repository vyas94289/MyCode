//
//  CartProductDataSource.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 26/04/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import Foundation
import UIKit

class CartDataSource: NSObject, UITableViewDataSource, UITableViewDelegate {
    var data:[CartModel.Product] = []
    var viewController:CartVC?
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if data.isEmpty{
            tableView.noRecords("Cart is Empty".localized)
        }else{
            tableView.backgroundView = nil
        }
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CartProductCell
        let row = data[indexPath.row]
        cell.ivThumb.setImageWith(url: row.thumb)
        cell.lblName.text = row.name
        cell.lblPrice.text = row.price
        cell.btnQuantity.setTitle(row.quantity, for: .normal)
        cell.btnQuantity.tag = indexPath.row
        cell.btnQuantity.addTarget(self, action: #selector(showAlertPicker(_:)), for: .touchUpInside)
        cell.btnDelete.tag = indexPath.row
        cell.btnDelete.addTarget(self, action: #selector(removeProduct(_:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let width = UIScreen.main.bounds.width
        if width <= 375{
            return (width+24) / 3.125
        }
        return 120
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let storyboard = UIStoryboard(name: StoryboardId.product, bundle: nil)
        let vc = storyboard.instantiateViewController(withIdentifier: ProductDetailVC.sceneId) as! ProductDetailVC
        vc.productId = data[indexPath.row].productID
        self.viewController?.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc func showAlertPicker( _ sender:UIButton) {
       
        let alertView = UIAlertController(title: "Select quantity".localized, message: "\n\n\n\n\n\n", preferredStyle: .alert)
        
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self
        
        alertView.view.addSubview(pickerView)
    
        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0) + 1
            if self.data[sender.tag].quantity != String(row){
                 sender.setTitle(String(row), for: .normal)
                self.data[sender.tag].quantity = String(row)
                self.updateQuanity(param: ["key":self.data[sender.tag].key ?? "",
                                           "quantity":String(row)])
            }
            
        }
        alertView.addAction(action)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertView.addAction(cancelAction)
        viewController?.present(alertView, animated: true)
        if let value = self.data[sender.tag].quantity,
            let quantity = Int(value),quantity < 100{
            pickerView.selectRow(quantity-1, inComponent: 0, animated: false)
        }
        
    }
    
    @objc func removeProduct(_ sender:UIButton){
        DataRequest.post(url: URLs.cart, method: "DELETE", param: ["key" : self.data[sender.tag].key ?? ""]) { (response) in
            switch response{
            case .success(let data):
                do{
                    let info = try JSONDecoder().decode(CommonModel.self, from: data)
                    if info.success ?? 0 == 0{
                        let message = info.error?.first ?? Const.wentWrong
                        self.viewController?.simpleAlertShow(title: Const.error, message: message, click: {
                            self.viewController?.dataRequest()
                        })
                    }else{
                        self.viewController?.dataRequest()
                    }
                }catch(let error){
                    print(error)
                    self.viewController?.simpleAlertShow(title: Const.error, message: Const.wentWrong)
                    self.viewController?.dataRequest()
                }
                break
            case .failure(let error,let message):
                print(error)
                self.viewController?.simpleRetryCancelAlert(message: message, retry: {
                    self.removeProduct(sender)
                })
                break
            }
        }
    }
    
    func updateQuanity(param:[String:String]){
        DataRequest.post(url: URLs.updateCart, method: "PUT", param: param) { (response) in
            switch response{
            case .success(let data):
                do{
                    let info = try JSONDecoder().decode(CommonModel.self, from: data)
                    if info.success ?? 0 == 0{
                        let message = info.error?.first ?? Const.wentWrong
                        self.viewController?.simpleAlertShow(title: Const.error, message: message, click: {
                            self.viewController?.dataRequest()
                        })
                    }else{
                        self.viewController?.dataRequest()
                    }
                }catch(let error){
                    print(error)
                    self.viewController?.simpleAlertShow(title: Const.error, message: Const.wentWrong)
                    self.viewController?.dataRequest()
                }
                break
            case .failure(let error,let message):
                print(error)
                self.viewController?.simpleRetryCancelAlert(message: message, retry: {
                    self.updateQuanity(param: param)
                })
                break
            }
        }
    }
}

extension CartDataSource:UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 99
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row+1)
    }
    
}
