import UIKit
import AVFoundation
import Kingfisher
import Cartography

class KSMessageCell: UITableViewCell {
    static let NotificationName = "VoicePlayHasInterrupt"
    var avatarBtnView: UIButton!
    var messageView: KSMessageContentView!
    var timeLable: UILabel!
//    var nameLabel: UILabel!
    var message: KSMessage!
    var audio: KSAVAudioPlayer!
    
    let Margin: CGFloat = 5//内间距
    let AvatarWH: CGFloat = 44//头像宽高
    var contentVoiceIsPlaying = false
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        constrain(contentView){view in
            view.edges == view.superview!.edges
        }
        self.backgroundColor = UIColor.clearColor()
        self.selectionStyle = UITableViewCellSelectionStyle.None
        //1.创建时间
        self.timeLable = UILabel()
        self.timeLable.textAlignment = NSTextAlignment.Center
        self.timeLable.textColor = TimeLabelTextColor
        self.timeLable.font = ChatTimeFont
        self.contentView.addSubview(self.timeLable)

        //2.创建头像
        self.avatarBtnView = UIButton()
        self.avatarBtnView.layer.cornerRadius = CornerRadius
        self.avatarBtnView.layer.masksToBounds = true
        self.contentView.addSubview(avatarBtnView)
        //3.创建姓名
//        self.nameLabel = UILabel()
//        self.nameLabel.textAlignment = NSTextAlignment.Center
//        self.nameLabel.textColor = TimeLabelTextColor
//        self.nameLabel.font = ChatTimeFont
//        self.contentView.addSubview(self.nameLabel)
//        nameLabel.constrainWidth(70)


        //4.创建聊天框
        self.messageView = KSMessageContentView()
        self.messageView.layer.cornerRadius = CornerRadius
        self.messageView.layer.masksToBounds = true
        self.messageView.addTarget(self, action: "didMessageView", forControlEvents: UIControlEvents.TouchUpInside)
        self.contentView.addSubview(self.messageView)
        constrain(timeLable,avatarBtnView,messageView) { view1,view2,view3 in
            view1.leading == view1.superview!.leading
            view1.trailing == view1.superview!.trailing
            view1.top == view1.superview!.top + Margin
            view2.top == view1.bottom+Margin
            view2.width == AvatarWH
            view2.height == AvatarWH
            view3.top == view1.bottom+Margin
            view1.superview!.bottom >= view2.bottom + Margin
            view1.superview!.bottom >= view3.bottom + Margin
        }
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "KSAVAudioPlayerDidFinishPlay", name: KSMessageCell.NotificationName, object: nil)
    }
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //设置cell的内容Frame
    func setMessageFrame(message: KSMessage){
        self.message = message
        //1.是否显示时间
        if self.message.showDateLabel{
            self.timeLable.text = self.message.strTime!.relativeTimeToString()
            self.timeLable.sizeToFit()
        }
        
        //2.头像、消息的布局
        self.messageView.initContent(message)
        if self.message.from == .Other{
            messageView.setBackgroundImage(UIImage(named: "Receiving_Solid"), forState: .Normal)
            constrain(avatarBtnView,messageView) { view1,view2 in
                view1.leading == view1.superview!.leading + Margin
                view2.leading == view1.trailing + Margin
            }
        }else{
            messageView.setBackgroundImage(UIImage(named: "Sending_Solid"), forState: .Normal)
            constrain(avatarBtnView,messageView) { view1,view2 in
                view1.trailing == view1.superview!.trailing - Margin
                view2.trailing == view1.leading - Margin
            }
        }
        //3.获取头像
//        avatarBtnView.kf_setBackgroundImageWithURL(NSURL(string: self.message!.strIcon!)!,forState:.Normal)
        
        let request:NSURLRequest = NSURLRequest(URL:NSURL(string: self.message!.strIcon!)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{(response:NSURLResponse!,data:NSData!,error:NSError!)->Void in
            if data != nil{
                let img = UIImage(data: data)
                if img != nil{
                    self.avatarBtnView.setBackgroundImage(img, forState: UIControlState.Normal)
                }
            }
        })
    
    }
    
    //MARK: 处理点击聊天类容事件
    func didMessageView(){
        switch self.message.type{
        case .Text:
            break
        case .Picture:
            break
        case .Voice:
            if !contentVoiceIsPlaying{
                NSNotificationCenter.defaultCenter().postNotificationName(KSMessageCell.NotificationName, object: nil)
                contentVoiceIsPlaying = true
                self.audio = KSAVAudioPlayer.sharedInstance
                self.audio.delegate = self
                if self.message.voice != nil{
                    self.audio.playSongWithData(self.message.voice!)
                }else if self.message.voiceURL != nil{
                    self.audio.playSongWithUrl(self.message.voiceURL!)
                }
            }else{
                KSAVAudioPlayerDidFinishPlay()
            }
           
            break
        default:
            break
        }
    }
}

extension KSMessageCell: KSAVAudioPlayerDelegate{
    func KSAVAudioPlayerBeiginLoadVoice(){
        self.messageView.beginLoadVoice()
    }
    func KSAVAudioPlayerBeiginPlay(){
        UIDevice.currentDevice().proximityMonitoringEnabled = true
        self.messageView.didLoadVoice()
    }
    func KSAVAudioPlayerDidFinishPlay(){
        UIDevice.currentDevice().proximityMonitoringEnabled = false
        contentVoiceIsPlaying = false
        self.messageView.stopPlay()
        KSAVAudioPlayer.sharedInstance.stopSound()
    }
}
