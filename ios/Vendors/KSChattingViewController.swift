import UIKit
import Cartography
import CoreStore

class KSChattingViewController: UIViewController{
    
    var tableView: KSChatTableView!
    var inputMessageView: KSInputMessageView!
    let photohandelHeight: CGFloat = 160
    var inputMessageViewBottomConstrain: Cartography.ConstraintGroup?
    override func viewDidLoad() {
        super.viewDidLoad()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardChange:", name: UIKeyboardWillHideNotification, object: nil)
         initChatView()
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        tabBarController?.tabBar.hidden = true
    }

    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        tabBarController?.tabBar.hidden = false
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func initChatView(){//初始聊天界面
        inputMessageView = KSInputMessageView()
        view.addSubview(inputMessageView)
        tableView = KSChatTableView()
        view.addSubview(tableView)
        constrain(tableView,inputMessageView){ view1,view2 in
            view2.height == 40
            view2.leading == view2.superview!.leading
            view2.trailing == view2.superview!.trailing
            view1.leading == view1.superview!.leading
            view1.trailing == view1.superview!.trailing
            view1.top == view1.superview!.top
            view1.bottom == view2.top
        }
        inputMessageViewBottomConstrain = constrain(inputMessageView){ view in
            view.bottom == view.superview!.bottom
        }
    }
    
    func keyboardChange(notification: NSNotification){
        let userInfo = notification.userInfo! as NSDictionary
        let animationDuration = userInfo.valueForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        let keyboardEndFrame = (userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        let rectH = keyboardEndFrame.size.height
        UIView.animateWithDuration(animationDuration, delay: 0, options: UIViewAnimationOptions.AllowAnimatedContent, animations: { () -> Void in
            if notification.name == UIKeyboardWillShowNotification{
                self.inputMessageViewBottomConstrain = constrain(self.inputMessageView, replace: self.inputMessageViewBottomConstrain!){ view in
                    view.bottom == view.superview!.bottom - rectH
                }
            }else{
                self.inputMessageViewBottomConstrain = constrain(self.inputMessageView, replace: self.inputMessageViewBottomConstrain!){ view in
                    view.bottom == view.superview!.bottom
                }
            }
            }, completion: nil)
        if notification.name == UIKeyboardWillShowNotification{
             tableView.scrollToBottom()
        }
    }
}



