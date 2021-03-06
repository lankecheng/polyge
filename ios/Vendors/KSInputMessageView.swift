import UIKit
protocol KSInputMessageViewDelegate: NSObjectProtocol{
    func sendMessageText(text: String)
    func sendMessagePhoto(data: NSData, fileName: String)
    func sendMessageVoice(voiceData: NSData,voiceTime: UInt8)
}
class KSInputMessageView: UIView{
    lazy var audioRecorder: KSAVAudioRecorder = {
        KSAVAudioRecorder(delegate: self)
    }()
    var delegate: KSInputMessageViewDelegate?
    
    var inputTextView: KMPlaceholderTextView!
    var sendMessageBtn: UIButton!
    var isAbleToSendText = false
    
    var voiceOrTextBtn: UIButton!
    var pressstartRecorderBtn: UIButton!
 
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        self.backgroundColor = UIColor.whiteColor()
        //设置边框
        layer.borderWidth = kBorderWidth
        layer.borderColor = kBorderColor

        //切换语音和文字输入框按钮
        voiceOrTextBtn = UIButton(type:.Custom) as UIButton
        addSubview(voiceOrTextBtn)
        voiceOrTextBtn.constrainWidth(30).constrainLeading(5).constrainTop(5).constrainCenterY()

        voiceOrTextBtn.setBackgroundImage(UIImage(named: "Edit"), forState: UIControlState.Normal)
        let speechImage = UIImage(named: "Speech")
        let stretchableButtonImage = speechImage?.stretchableImageWithLeftCapWidth(12, topCapHeight: 0)
        voiceOrTextBtn.setBackgroundImage(stretchableButtonImage, forState: UIControlState.Selected)
        voiceOrTextBtn.addTarget(self, action: "didVoiceOrTextBtn:", forControlEvents: UIControlEvents.TouchUpInside)

        //输入框
        inputTextView = KMPlaceholderTextView()
        addSubview(inputTextView)
        inputTextView.ksconstrain(.Leading,.Equal,voiceOrTextBtn,.Trailing,constant:10)
        inputTextView.constrainTop(5).constrainCenterX().constrainCenterY()
        inputTextView.delegate = self
        inputTextView.placeholder = "Input the contents here"
        
        
        //文字发送按钮
        sendMessageBtn = UIButton(type:.Custom) as UIButton
        addSubview(sendMessageBtn)
        sendMessageBtn.constrainTop(5).constrainTrailing(-5).constrainWidth(30).constrainCenterY()
        sendMessageBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        sendMessageBtn.setTitleColor(KSColor.hightColor, forState: .Normal)
        sendMessageBtn.layer.cornerRadius = kCornerRadius
        sendMessageBtn.clipsToBounds = true
        getCurBtnShowType()
            sendMessageBtn.addTarget(self, action: "didSendMessageBtn", forControlEvents: UIControlEvents.TouchUpInside)
        //按下开始录音按钮
        pressstartRecorderBtn = UIButton(type: .Custom) as UIButton
        addSubview(pressstartRecorderBtn)
        pressstartRecorderBtn.constrainTop(5).constrainCenterX().constrainCenterY()
        pressstartRecorderBtn.ksconstrain(.Leading,.Equal,voiceOrTextBtn,.Trailing,constant:50)
        
        pressstartRecorderBtn.layer.cornerRadius = kCornerRadius
        pressstartRecorderBtn.layer.masksToBounds = true
        pressstartRecorderBtn.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        pressstartRecorderBtn.layer.borderWidth = kBorderWidth
        pressstartRecorderBtn.backgroundColor = UIColor.whiteColor()
        pressstartRecorderBtn.setTitleColor(KSColor.tintColor, forState: UIControlState.Normal)
        pressstartRecorderBtn.setTitle("按住说话", forState: UIControlState.Normal)
        pressstartRecorderBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        pressstartRecorderBtn.addTarget(self, action: "beginRecordVoice:", forControlEvents: UIControlEvents.TouchDown)
        pressstartRecorderBtn.addTarget(self, action: "endRecordVoice:", forControlEvents: UIControlEvents.TouchUpInside)
        pressstartRecorderBtn.addTarget(self, action: "cancelRecordVoice:", forControlEvents: UIControlEvents.TouchUpOutside)
        pressstartRecorderBtn.addTarget(self, action: "RemindDragExit:", forControlEvents: UIControlEvents.TouchDragExit)
        pressstartRecorderBtn.addTarget(self, action: "RemindDragEnter:", forControlEvents: UIControlEvents.TouchDragEnter)
        pressstartRecorderBtn.hidden = true
    }
    
    func getCurBtnShowType(){
        let image: UIImage
        if inputTextView.text.characters.count>0 {
            sendMessageBtn.setTitle("发送", forState: .Normal)
            sendMessageBtn.setBackgroundImage(nil, forState: .Normal)
            image = KSColor.createImageWithColor(KSColor.tintColor)
        }else{
            sendMessageBtn.setTitle(nil, forState: .Normal)
            image = UIImage(named: "More")!
            sendMessageBtn.setBackgroundImage(image, forState: .Normal)
        }
    }
    
    //MARK: 处理语音按钮的各种方法-----
    var recorderTime: Int!
    var recorderTimer: NSTimer!
    func beginRecordVoice(button: UIButton){
        audioRecorder.startRecord()
            recorderTime = 0
            recorderTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countVoiceTime", userInfo: nil, repeats: true)
            KSProgressHUD.show(superview!)
    }
    func endRecordVoice(button: UIButton?){
        if recorderTimer != nil{
            audioRecorder.stopRecord()
            recorderTimer?.invalidate()
            recorderTimer = nil
        }
    }
    
    func cancelRecordVoice(button: UIButton){
        if recorderTimer != nil{
            audioRecorder.cancelRecord()
            recorderTimer?.invalidate()
            recorderTimer = nil
        }
        KSProgressHUD.dismissWithError("录音取消")
    }
    func RemindDragExit(button: UIButton){
        KSProgressHUD.changeSubTitle("松开取消发送")
    }
    func RemindDragEnter(button: UIButton){
        KSProgressHUD.changeSubTitle("上滑取消发送")
    }
    func countVoiceTime(){
        recorderTime!++
        if recorderTime >= 60{
            endRecordVoice(nil)
        }
    }
    func didVoiceOrTextBtn(btn: UIButton){//点击切换语音和文字输入
        btn.selected = !btn.selected
        if btn.selected{
            self.inputTextView.resignFirstResponder()
            self.inputTextView.hidden = true
            self.pressstartRecorderBtn.hidden = false
        }else{
            self.inputTextView.hidden = false
            self.pressstartRecorderBtn.hidden = true
        }
        
    }
    func didSendMessageBtn(){
        if self.inputTextView.text.characters.count > 0{
            self.inputTextView.resignFirstResponder()
            self.delegate?.sendMessageText(self.inputTextView.text)
            self.inputTextView.text = ""
            //重新滚到顶
            self.inputTextView.scrollRangeToVisible(NSMakeRange(0,0))
            self.getCurBtnShowType()
        }else{
            self.inputTextView.resignFirstResponder()
            let sheet = UIActionSheet(title: nil, delegate: self, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Images")
            sheet.showInView(self.window!)
        }
        
    }

}
extension KSInputMessageView: UITextViewDelegate {
    func textViewDidBeginEditing(textView: UITextView) {
        getCurBtnShowType()
    }
    
    func textViewDidChange(textView: UITextView) {
       getCurBtnShowType()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        getCurBtnShowType()
    }
}
extension KSInputMessageView: KSAVAudioRecorderDelegate {

    func failRecord(failedStr: String){
        KSProgressHUD.dismissWithError(failedStr)
        //缓冲消失时间（最好有回调消失完成)
        pressstartRecorderBtn.enabled = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.pressstartRecorderBtn.enabled = true
        })
        
    }
    func endConvertWithData(voiceData: NSData,voiceTime: UInt8){
        delegate?.sendMessageVoice(voiceData,voiceTime: voiceTime)
        KSProgressHUD.dismissWithSuccess("录音成功")
        
        //缓冲消失时间（最好有回调消失完成）
        pressstartRecorderBtn.enabled = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.pressstartRecorderBtn.enabled = true
        })
        
    }
}
extension KSInputMessageView: UIActionSheetDelegate {
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
        var sourceType :UIImagePickerControllerSourceType = .Camera
        if !UIImagePickerController.isSourceTypeAvailable(sourceType) {
            sourceType = .PhotoLibrary
        }
        let picker = UIImagePickerController()
//        picker.delegate = self
        picker.allowsEditing = true//设置可编辑
        picker.sourceType = sourceType
        self.viewController()?.presentViewController(picker, animated: true, completion: nil)//进入照相界面
    }
    func getImage(){
        let pickerImage = UIImagePickerController()
        if !UIImagePickerController.isSourceTypeAvailable(.PhotoLibrary){
            pickerImage.sourceType = .PhotoLibrary
            pickerImage.mediaTypes = UIImagePickerController.availableMediaTypesForSourceType(pickerImage.sourceType)!
        }
//        pickerImage.delegate = self
        pickerImage.allowsEditing = true
        self.viewController()?.presentViewController(pickerImage, animated: true, completion: nil)
    }
}
extension KSInputMessageView: UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: AnyObject]){
        let img = info[UIImagePickerControllerOriginalImage] as! UIImage
        let smallImg = self.scaleFromImage(img, size: CGSize(width: img.size.width * 0.8,height: img.size.height * 0.8))
        var pathExtension = "png"
        if let imgUrl = info[UIImagePickerControllerReferenceURL] as? NSURL{
            pathExtension = imgUrl.pathExtension!
        }
        let format = NSDateFormatter()
        format.dateFormat="yyyyMMddHHmmss"
        let currentFileName = "\(format.stringFromDate(NSDate())).\(pathExtension)"
        let imageData = UIImagePNGRepresentation(smallImg)
        var paths = NSSearchPathForDirectoriesInDomains(.DocumentDirectory, .UserDomainMask, true)
        let documentsDirectory : AnyObject = paths[0]
        let fullPathToFile = documentsDirectory.stringByAppendingPathComponent(currentFileName)
        let filemanager = NSFileManager.defaultManager()
        if filemanager.fileExistsAtPath(fullPathToFile) {
            // probably won't happen. want to do something about it?
        }else{
            
        }
        imageData!.writeToFile(fullPathToFile, atomically: false)
        let uploadImgUrl = NSURL(fileURLWithPath: fullPathToFile)
        let data = NSData(contentsOfFile: uploadImgUrl.path!)
        
        picker.dismissViewControllerAnimated(true, completion: nil)
        delegate!.sendMessagePhoto(data!, fileName: currentFileName)
    }
    
    //修改图片尺寸
    func scaleFromImage(image:UIImage,size:CGSize)->UIImage{
        UIGraphicsBeginImageContext(size)
        image.drawInRect(CGRectMake(0, 0, size.width, size.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
    
    //cancel后执行的方法
    func imagePickerControllerDidCancel(picker: UIImagePickerController){
        picker.dismissViewControllerAnimated(true, completion: nil)
    }
}
