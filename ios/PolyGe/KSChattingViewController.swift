import UIKit
import Cartography
class KSChattingViewController: UIViewController,UIActionSheetDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
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
  
    override func viewDidLayoutSubviews() {
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
        inputMessageView.actionSheetDelegate = self
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
        chat_tv.scrollToBottom()
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
    //MARK: UIActionSheetDelegate
    func actionSheet(actionSheet: UIActionSheet, clickedButtonAtIndex buttonIndex: Int) {
        if buttonIndex == 1 {
            getCamera()
        }else if buttonIndex == 2 {
            getImage()
        }
    }
    
    
    //打开相机
    func getCamera(){
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        var sourceType = UIImagePickerControllerSourceType.Camera
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera){
            sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        }
        var picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    func getImage(){
        var pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.PhotoLibrary){
            pickerImage.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        presentViewController(pickerImage, animated: true, completion: nil)
    }
    //选择好照片后choose后执行的方法
    // MARK: UIImagePickerControllerDelegate
    var uploadImgUrl:NSURL?
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]){
        println("choose--------->>")
        var img = info[UIImagePickerControllerOriginalImage] as! UIImage
        var smallImg = self.scaleFromImage(img, size: CGSize(width: img.size.width * 0.8,height: img.size.height * 0.8))
        println(img.size)
        println(smallImg.size)
        var pathExtension = "png"
        if let imgUrl = info[UIImagePickerControllerReferenceURL] as? NSURL{
            pathExtension = imgUrl.pathExtension!
        }
        var format = NSDateFormatter()
        format.dateFormat="yyyyMMddHHmmss"
        var currentFileName = "\(format.stringFromDate(NSDate())).\(pathExtension)"//"\(appDelegate.user.id!)-avatar-\(format.stringFromDate(NSDate())).\(pathExtension)"
        var imageData = UIImagePNGRepresentation(smallImg)
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        var documentsDirectory : AnyObject = paths[0]
        var fullPathToFile = documentsDirectory.stringByAppendingPathComponent(currentFileName)
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(fullPathToFile) {
            // probably won't happen. want to do something about it?
            println("photo exists")
        }else{
            
        }
        imageData.writeToFile(fullPathToFile, atomically: false)
        uploadImgUrl = NSURL(fileURLWithPath: fullPathToFile)
        var data = NSData(contentsOfFile: self.uploadImgUrl!.path!)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        println("choose----ss----->>")
        sendMessagePhoto(data!, fileName: currentFileName)
        println("choose----ssssssss----->>")
    }
    
    //修改图片尺寸
    func scaleFromImage(image:UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        var newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        println("cancel--------->>")
        picker.dismissViewControllerAnimated(true, completion: nil)
    }


}

extension KSChattingViewController: KSInputMessageViewDelegate{
    func sendMessageText(message: String) {
        var messageDict = NSMutableDictionary()
        messageDict.setValue(message, forKey: "strContent")
        messageDict.setValue(NSDate(), forKey: "strTime")
        messageDict.setValue("蛋羹先生", forKey: "strName")
        messageDict.setValue(0, forKey: "type")
        messageDict.setValue(1, forKey: "from")
        messageDict.setValue("http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png", forKey: "strIcon")
        var message = KSMessage()
        message.setMessageWithDic(messageDict)
        chat_tv.sendMessage(message)

    }
    
    func sendMessagePhoto(data: NSData, fileName: String){
        var messageDict = NSMutableDictionary()
        messageDict.setValue(NSDate(), forKey: "strTime")
        messageDict.setValue("发图好玩啊", forKey: "strName")
        messageDict.setValue(1, forKey: "type")
        messageDict.setValue(1, forKey: "from")
        messageDict.setValue("http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png", forKey: "strIcon")
        messageDict.setValue(UIImage(data: data), forKey: "picture")
        var message = KSMessage()
        message.setMessageWithDic(messageDict)
         chat_tv.sendMessage(message)
    }
    func sendMessageVoice(voiceURL: NSURL, fileName: String, voiceTime: Int){
        var messageDict = NSMutableDictionary()
        messageDict.setValue(NSDate(), forKey: "strTime")
        messageDict.setValue("说话也好玩", forKey: "strName")
        messageDict.setValue(2, forKey: "type")
        messageDict.setValue(1, forKey: "from")
        messageDict.setValue("http://sys.bansuikj.com/uploads/idcard/1428054233-0de32994c23efd12dfa2afaf5c6ae6d6.png", forKey: "strIcon")
        messageDict.setValue(voiceURL, forKey: "voiceURL")
        messageDict.setValue(voiceTime, forKey: "strVoiceTime")
        var message = KSMessage()
        message.setMessageWithDic(messageDict)
        chat_tv.sendMessage(message)
    }
}


