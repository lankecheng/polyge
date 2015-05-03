import UIKit
//import KMPlaceholderTextView
protocol KSInputMessageViewDelegate: NSObjectProtocol{
    func sendMessageText(message: String)
    func sendMessagePhoto(data: NSData, fileName: String)
    func sendMessageVoice(voiceURL: NSURL, fileName: String, voiceTime: Int)
}
class KSInputMessageView: UIView, UITextViewDelegate, UITextFieldDelegate,UIActionSheetDelegate,KSAVAudioRecorderDelegate{
    lazy var audioRecorder: KSAVAudioRecorder = {
        KSAVAudioRecorder(delegate: self)
    }()
    var delegate: KSInputMessageViewDelegate?
    var actionSheetDelegate: UIActionSheetDelegate?
    
    var inputTextView: KMPlaceholderTextView!
    var sendMessageBtn: UIButton!
    var isAbleToSendText = false
    
    var voiceOrTextBtn: UIButton!
    var pressstartRecorderBtn: UIButton!
 
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    func commonInit() {
        //设置边框
        layer.borderWidth = BorderWidth
        layer.borderColor = BorderColor

        //切换语音和文字输入框按钮
        voiceOrTextBtn = UIButton.buttonWithType(.Custom) as! UIButton
        addSubview(voiceOrTextBtn)
    voiceOrTextBtn.constrainWidth(30).constrainLeading(5).constrainTop(5).constrainCenterY()

        voiceOrTextBtn.setBackgroundImage(UIImage(named: "Edit"), forState: UIControlState.Normal)
        var speechImage = UIImage(named: "Speech")
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
        sendMessageBtn = UIButton.buttonWithType(.Custom) as! UIButton
        addSubview(sendMessageBtn)
        sendMessageBtn.constrainTop(5).constrainTrailing(-5).constrainWidth(30).constrainCenterY()
        sendMessageBtn.titleLabel?.font = UIFont.systemFontOfSize(14)
        sendMessageBtn.setTitleColor(KSColor.hightColor, forState: .Normal)
        sendMessageBtn.layer.cornerRadius = CornerRadius
        sendMessageBtn.clipsToBounds = true
        getCurBtnShowType()
        sendMessageBtn.addTarget(self, action: "didSendMessageBtn", forControlEvents: UIControlEvents.TouchUpInside)
        
        
        //按下开始录音按钮
        pressstartRecorderBtn = UIButton.buttonWithType(.Custom) as! UIButton
        addSubview(pressstartRecorderBtn)
        pressstartRecorderBtn.constrainTop(5).constrainCenterX().constrainCenterY()
        pressstartRecorderBtn.ksconstrain(.Leading,.Equal,voiceOrTextBtn,.Trailing,constant:50)
        
        pressstartRecorderBtn.layer.cornerRadius = CornerRadius
        pressstartRecorderBtn.layer.masksToBounds = true
        pressstartRecorderBtn.layer.borderColor = UIColor.lightGrayColor().colorWithAlphaComponent(0.5).CGColor
        pressstartRecorderBtn.layer.borderWidth = BorderWidth
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
    
    func didVoiceOrTextBtn(btn: UIButton){//点击切换语音和文字输入
        btn.selected = !btn.selected
        if btn.selected{
            inputTextView.resignFirstResponder()
            inputTextView.hidden = true
            pressstartRecorderBtn.hidden = false
        }else{
            inputTextView.hidden = false
            pressstartRecorderBtn.hidden = true
        }
    }
    
    func getCurBtnShowType(){
        isAbleToSendText = count(inputTextView.text)>0
        let image: UIImage
        if isAbleToSendText {
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
        println("--------begin")
        audioRecorder.startRecord()
        if audioRecorder.recorder != nil{
            recorderTime = 0
            recorderTimer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: "countVoiceTime", userInfo: nil, repeats: true)
            KSProgressHUD.show(superview!)
        }
    }
    func endRecordVoice(button: UIButton?){
        println("--------send")
        if recorderTimer != nil{
            audioRecorder.stopRecord()
            recorderTimer?.invalidate()
            recorderTimer = nil
        }
    }
    
    func cancelRecordVoice(button: UIButton){
        println("--------cancel")
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
        println("--------\(recorderTime)")
        recorderTime!++
        if recorderTime >= 60{
            endRecordVoice(nil)
        }
    }
    //-------------------------------------------

    
    //MARK: UITextViewDelegate
    func textViewDidBeginEditing(textView: UITextView) {
        getCurBtnShowType()
    }
    
    func textViewDidChange(textView: UITextView) {
       getCurBtnShowType()
    }
    
    func textViewDidEndEditing(textView: UITextView) {
        getCurBtnShowType()
    }
    
    func textFieldDidBeginEditing(textField: UITextField) {
        voiceOrTextBtn.selected = false
        inputTextView.hidden = false
        pressstartRecorderBtn.hidden = true
    }
    //--------------------------------
    
    //MARK: 发送消息----
    func didSendMessageBtn(){
        if count(inputTextView.text) > 0{
            inputTextView.resignFirstResponder()
            delegate?.sendMessageText(self.inputTextView.text)
            inputTextView.text = ""
            //重新滚到顶
            inputTextView.scrollRangeToVisible(NSMakeRange(0,0))
            getCurBtnShowType()
        }else{
            inputTextView.resignFirstResponder()
            let sheet = UIActionSheet(title: nil, delegate: actionSheetDelegate, cancelButtonTitle: "Cancel", destructiveButtonTitle: nil, otherButtonTitles: "Camera", "Images")
            sheet.showInView(self.window)
        }
    }
    //MARK: KSAVAudioRecorderDelegate
    func failRecord(failedStr: String){
        KSProgressHUD.dismissWithError(failedStr)
        //缓冲消失时间（最好有回调消失完成)
        pressstartRecorderBtn.enabled = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.pressstartRecorderBtn.enabled = true
        })
        
    }
    func endConvertWithData(voiceURL: NSURL, fileName: String, voiceTime: Int){
        delegate?.sendMessageVoice(voiceURL, fileName: fileName, voiceTime: voiceTime)
        KSProgressHUD.dismissWithSuccess("录音成功")
        
        //缓冲消失时间（最好有回调消失完成）
        pressstartRecorderBtn.enabled = false
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), {
            self.pressstartRecorderBtn.enabled = true
        })
        
    }

}
