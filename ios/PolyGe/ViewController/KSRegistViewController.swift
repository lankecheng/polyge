//
//  KSRegistViewController.swift
//  PolyGe
//
//  Created by king on 15/6/22.
//  Copyright © 2015年 king. All rights reserved.
//

import UIKit
import Alamofire
import MBProgressHUD
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
        guard self.userPassTextField.text == self.confirmUserPassTextField.text else{
            self.view.showTextHUD("密码不一致请重新输入")
            return
        }
        var parameters = ["pwd":self.userPassTextField.text!]
        if self.userNameTextField.text!.checkMobileNumble() {
            parameters["phone"] = self.userNameTextField.text!
        }else{
            parameters["email"] = self.userNameTextField.text!
        }
        let hud = MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        hud.labelText = "注册中"
        Alamofire.request(.GET, URLString: NSUserDefaults.host+"/register", parameters: parameters).responseJSON {
            (request, response, data, error) in
            hud.removeFromSuperview()
            if response?.statusCode == 302 {
                self.navigationController?.pushViewController(UIStoryboard(name: "Main", bundle: NSBundle.mainBundle()).instantiateInitialViewController()!, animated: true)
            }
        }


     
    }

}
