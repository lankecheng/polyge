//
//  KSLoginViewController.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit

class KSLoginViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPassTextField: UITextField!
    @IBOutlet weak var userLoginBtn: UIButton!
    var isRelogin = false
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if defaults["ipaddress"] == nil {
            defaults["ipaddress"] = "http://access.teamtalk.im:8080/msg_server"
        }
        let username = defaults["username"] as? String
        if username != nil {
            userNameTextField.text = username
        }
        let password = defaults["password"] as? String
        if password != nil {
            userPassTextField.text = password
        }
        if isRelogin {
            if username != nil && password != nil {
                if let autologin = defaults["autologin"] as? Bool {
                    if autologin.boolValue {
                        self.login(self.userLoginBtn)
                    }
                }
            }
        }
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.userNameTextField {
            self.userNameTextField.resignFirstResponder()
            self.userPassTextField.becomeFirstResponder()
        }else if textField == self.userPassTextField {
            self.login(self.userLoginBtn)
        }
        return true
    }
    
    //MARK: action
    @IBAction func login(sender: UIButton?) {
        userLoginBtn.enabled = false
        let userName = userNameTextField.text
        let password = userPassTextField.text
        if userName!.characters.count == 0 || password!.characters.count == 0 {
            userLoginBtn.enabled = true
           return
        }
        let indicator = WIndicator.showIndicatorAddedTo(self.view, animation: true)
        indicator.text = "正在登录"
        
        LoginModule.loginWithUsername(userName!, password: password!) { result -> Void in
            if let error = result.error {
                self.userLoginBtn.enabled = true
                indicator.removeFromSuperview()
                let alert = UIAlertController(title: "错误", message: error.domain, preferredStyle: .Alert)
                let okAction = UIAlertAction(title: "确定", style: .Default, handler: nil)
                alert.addAction(okAction)
                self.presentViewController(alert,animated:true,completion:nil)

            } else if let user = result.value {
                RuntimeStatus.instance.user = user
                if RuntimeStatus.instance.pushToken != nil {
                    
                }
                if self.isRelogin {
                    self.dismissViewControllerAnimated(true, completion: nil)
                }else{
                    
                }
            }
            
        }
        
    }

}
