import UIKit
import Cartography
class KSChattingViewController: UIViewController{
    
    var cellArray: [Message]{
        get{
            return chat_tv.cellArray
        }
        set{
            chat_tv.cellArray = newValue
            chat_tv.reloadData()
        }
    }
    var chat_tv: KSChatTableView!
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
        inputMessageView.delegate = self
        chat_tv = KSChatTableView()
        view.addSubview(chat_tv)
        constrain(chat_tv,inputMessageView){ view1,view2 in
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
        var userInfo = notification.userInfo! as NSDictionary
        var animationDuration = userInfo.valueForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        var keyboardEndFrame = (userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        var rectH = keyboardEndFrame.size.height
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
             chat_tv.scrollToBottom()
        }
    }
}

extension KSChattingViewController: KSInputMessageViewDelegate{
    func sendMessageText(text: String) {
        let message = Message.create() as! Message
        message.createDate = NSDate()
        message.messageData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        message.createUserID = KSUserHelper.userID
        message.messageType = .Text
        chat_tv.sendMessage(message)
    }
    
    func sendMessagePhoto(data: NSData, fileName: String){
        let message = Message.create() as! Message
        message.messageData = data
        message.createDate = NSDate()
        message.createUserID = KSUserHelper.userID
        message.messageType = .Picture
         chat_tv.sendMessage(message)
    }
    func sendMessageVoice(voiceData: NSData,voiceTime: Int16){
        let message = Message.create() as! Message
        message.messageData = voiceData
        message.voiceTime = voiceTime
        message.createDate = NSDate()
        message.createUserID = KSUserHelper.userID
        message.messageType = .Voice
        chat_tv.sendMessage(message)
    }
}


