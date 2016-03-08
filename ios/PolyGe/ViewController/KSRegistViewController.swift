//
//  KSRegistViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireSwiftyJSON

class KSRegisterViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var userNameTextField: UITextField!
    @IBOutlet weak var userPassTextField: UITextField!
    @IBOutlet weak var confirmUserPassTextField: UITextField!
    @IBOutlet weak var userRegisterButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    //MARK: UITextFieldDelegate
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        if textField == self.userNameTextField {
            self.userNameTextField.resignFirstResponder()
            self.userPassTextField.becomeFirstResponder()
        }else if textField == self.userPassTextField {
            self.userPassTextField.resignFirstResponder()
            self.confirmUserPassTextField.becomeFirstResponder()
        }else if textField == self.confirmUserPassTextField {
            self.confirmUserPassTextField.resignFirstResponder()
            self.register(self.userRegisterButton)
        }
        return true
    }
    //MARK: action
    @IBAction func register(sender: UIButton?) {
        guard self.userNameTextField.text?.characters.count > 0 else{
            self.view.showTextHUD("用户名不能为空")
            return
        }
//        guard self.userNameTextField.text?.characters.count > 0 else{
//            self.view.showTextHUD("手机号码或邮箱不能为空")
//            return
//        }
//        guard self.userNameTextField.text!.checkMobileNumble() || self.userNameTextField.text!.checkEmail() else{
//            self.view.showTextHUD("输入的手机号码或邮箱输入有误")
//            return
//        }
        guard self.userPassTextField.text?.characters.count > 0 else{
            self.view.showTextHUD("密码不能为空")
            return
        }
        guard self.userPassTextField.text == self.confirmUserPassTextField.text else{
            self.view.showTextHUD("密码不一致请重新输入")
            return
        }
        var parameters = ["pwd":self.userPassTextField.text!,"user_name":self.userNameTextField.text!]
//        if self.userNameTextField.text!.checkMobileNumble() {
//            parameters["phone"] = self.userNameTextField.text!
//        }else{
//            parameters["email"] = self.userNameTextField.text!
//        }
        
        
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = KSLocalizedString("注册中")
        Alamofire.request(.GET, NSUserDefaults.host+"/register", parameters: parameters).responseSwiftyJSON{
            (response) in
            let json = response.result.value!
            guard json["success"].boolValue else{
                hud.removeFromSuperview()
                self.view.showTextHUD(json["msg"].string!)
                return
            }
            hud.labelText = KSLocalizedString("登录中")
            Alamofire.request(.GET, NSUserDefaults.host+"/login", parameters: parameters).responseSwiftyJSON{
                (response) in
                let json = response.result.value!
                hud.removeFromSuperview()
                guard json["success"].boolValue  else{
                    self.view.showTextHUD(json["msg"].string!)
                    self.userRegisterButton.enabled = true
                    return
                }
                NSUserDefaults.token = json["result"]["token"].string!
                User.updateUser(json["result"])
                if parameters["phone"] != nil {
                    NSUserDefaults.loginType = .Mobile
                }else{
                    NSUserDefaults.loginType = .Email
                }
                self.ksNavigationController()?.presentViewController(KSStoryboard.mainViewController, animated: true, completion: nil)
            }
        }
    }
}
