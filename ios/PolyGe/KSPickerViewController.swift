//
//  ViewController.swift
//  Swift-Picker-iOS8
//
//  Created by Gabriel Massana on 20/06/2014.
//  Copyright (c) 2014 Gabriel Massana. All rights reserved.
//

import UIKit
class KSPickerViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    private var pickerView = UIPickerView()
    var callBackBlock: (Int -> Void)?
    var pickerData  = NSArray(){
        didSet(newValue){
            pickerView.selectRow(0, inComponent: 0, animated: false)
            pickerView.reloadAllComponents()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        let pickerToolbar = UIToolbar(frame: CGRectMake(10,0,view.frame.width-20, 44))
        pickerToolbar.barTintColor = UIColor.whiteColor()
        pickerToolbar.translucent = true
        
        var cancelBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Cancel, target: self, action: "cancelButtonClicked:")
        
        var flexSpace = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.FlexibleSpace, target: self, action: nil)
        let doneBtn = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Done, target: self, action: "doneButtonClicked:")
        
        pickerToolbar.setItems([cancelBtn,flexSpace,doneBtn], animated: true)
        
        pickerView.frame = CGRectMake(0.0, pickerToolbar.frame.height, view.frame.width, 162)
        pickerView.dataSource = self
        pickerView.delegate = self
        pickerView.showsSelectionIndicator = true;
        pickerView.backgroundColor = UIColor.whiteColor()

        view.addSubview(pickerToolbar)
        view.addSubview(pickerView)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func cancelButtonClicked(sender: UIBarButtonItem) {
        view.hidden = true
    }
    
    func doneButtonClicked(sender: UIBarButtonItem) {
        var index = pickerView.selectedRowInComponent(0)
        if callBackBlock != nil {
            callBackBlock!(index)
        }
        view.hidden = true
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
