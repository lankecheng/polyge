//
//  KSPickerView.swift
//  PolyGe
//
//  Created by king on 15/5/3.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSPickerView: UIView ,UIPickerViewDataSource, UIPickerViewDelegate {
    private var pickerView = UIPickerView()
    var callBackBlock: (Int -> Void)?
    var pickerData  = NSArray(){
        didSet(newValue){
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.reloadAllComponents()
        }
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        let toolBar = UIToolbar(frame: CGRectMake(0, 0, self.frame.width, 44))
        toolBar.barTintColor = UIColor.whiteColor()
        toolBar.translucent = true
        var cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonClicked:")
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonClicked:")
        
        toolBar.setItems([cancelBtn,flexSpace,doneBtn], animated: true)
        
        pickerView.frame = CGRectMake(0.0, toolBar.frame.height, self.frame.width, self.frame.height - 44)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true;
        pickerView.backgroundColor = UIColor.whiteColor()
        
        self.addSubview(toolBar)
        self.addSubview(pickerView)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func cancelButtonClicked(sender: UIBarButtonItem) {
        self.hidden = true
    }
    
    func doneButtonClicked(sender: UIBarButtonItem) {
        var index = pickerView.selectedRowInComponent(0)
        if callBackBlock != nil {
            callBackBlock!(index)
        }
        self.hidden = true
    }
    // MARK - Picker delegate
    
    func pickerView(_pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerData.count
    }
    
    func numberOfComponentsInPickerView(_pickerView: UIPickerView) -> Int {
        return 1
    }
    
    
    func pickerView(_pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        
        return pickerData[row] as! String
    }

}
