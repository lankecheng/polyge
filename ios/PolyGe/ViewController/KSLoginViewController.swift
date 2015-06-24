//
//  KSLoginViewController.swift
//  PolyGe
//
//  Created by king on 15/4/20.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import MBProgressHUD
import Alamofire
class KSLoginViewController: UIViewController,UITextFieldDelegate{
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPassTextField: UITextField!
    @IBOutlet weak var userLoginBtn: UIButton!
    var isRelogin = false
    
    override func viewDidLoad() {
        let defaults = NSUserDefaults.standardUserDefaults()
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
            self.userPassTextField.resignFirstResponder()
            self.login(self.userLoginBtn)
        }
        return true
    }
    
    //MARK: action
    @IBAction func login(sender: UIButton?) {
        guard self.userNameTextField.text?.characters.count > 0 else{
            self.view.showTextHUD("手机号码或邮箱不能为空")
            return
        }
        guard self.userNameTextField.text!.checkMobileNumble() || self.userNameTextField.text!.checkEmail() else{
            self.view.showTextHUD("输入的手机号码或邮箱输入有误")
            return
        }
        guard self.userPassTextField.text?.characters.count > 0 else{
            self.view.showTextHUD("密码不能为空")
            return
        }

        userLoginBtn.enabled = false
        let userName = userNameTextField.text
        let password = userPassTextField.text
        if userName!.characters.count == 0 || password!.characters.count == 0 {
            userLoginBtn.enabled = true
           return
        }
        var parameters = ["pwd":self.userPassTextField.text!,"client_id":"123"]
        if self.userNameTextField.text!.checkMobileNumble() {
            parameters["phone"] = self.userNameTextField.text!
        }else{
            parameters["email"] = self.userNameTextField.text!
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "正在登录"
        Alamofire.request(.GET, URLString: NSUserDefaults.host+"/login", parameters: parameters).responseSwiftyJSON({
            (request, response, json, error) in
            hud.removeFromSuperview()
            guard json["sucess"].boolValue  else{
                self.view.showTextHUD(json["msg"].string!)
                return
            }
            NSUserDefaults.token = json["result"]["token"].string!
            
            self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!, animated: true)
        })

    }

}
