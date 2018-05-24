//
//  PickerView.swift
//  Ethnoshop
//
//  Created by Dhaval Patel on 14/05/18.
//  Copyright © 2018 Dhaval Patel. All rights reserved.
//

import UIKit

class PickerView: UIAlertController,UIPickerViewDelegate,UIPickerViewDataSource {
    var onSelectItem : ((_ title:String,_ index:Int) -> Void)? = nil
    var data:[String] = []
    override func viewDidLoad() {
        super.viewDidLoad()

        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 50, width: 260, height: 115))
        pickerView.dataSource = self
        pickerView.delegate = self
        view.addSubview(pickerView)
        
        let action = UIAlertAction(title: "OK", style: .default) { [unowned pickerView, unowned self] _ in
            let row = pickerView.selectedRow(inComponent: 0)
            if let onSelect = self.onSelectItem {
                onSelect(self.data[row], row)
            }
        }
        addAction(action)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        addAction(cancelAction)
    }

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return data.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return data[row].capitalized
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
    }
    
    
}
