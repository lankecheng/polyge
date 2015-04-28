
import UIKit
import Cartography

class KSMessageContentView: UIButton {
    var backLabel: UILabel!
    var backImageView: UIImageView!
    var voiceImageView: UIImageView!
    var voiceTimeLabel: UILabel!
    var message: KSMessage!
    
    func initContent(message:KSMessage){//处理三种不同类型的消息界面...
        self.message = message
        var contentW: CGFloat = ScreenBounds.width - 120
        switch message.type{
        case .Text:
            self.backLabel = UILabel()
            self.addSubview(self.backLabel)
            constrain(backLabel) { view in
                view.leading == view.superview!.leading + 15
                view.top == view.superview!.top + 5
                view.superview!.width == view.width + 25
                view.superview!.height == view.height + 10
            }
            self.backLabel.textColor = UIColor.blackColor()
            self.backLabel.font = UIFont.systemFontOfSize(14)
            self.backLabel.numberOfLines = 0
            var attributedString = NSMutableAttributedString(string: self.message.strContent!)
            var paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.lineSpacing = 5
            attributedString.addAttribute(NSParagraphStyleAttributeName, value: paragraphStyle, range: NSMakeRange(0, count(self.message.strContent!)))
            self.backLabel.attributedText = attributedString
            self.backLabel.sizeToFit()
            
            break
        case .Picture:
            self.backImageView = UIImageView()
            self.addSubview(self.backImageView)
            self.backImageView.image = message.picture!
            var width = contentW
            var height = contentW
            if message.picture != nil{
                var pH = message.picture!.size.height
                var pW = message.picture!.size.width
                if pH > pW{
                    width = pW * contentW / pH
                }else{
                    height = pH * contentW / pW
                }
            }
            constrain(backImageView) { view in
                view.width == width
                view.height == height
                view.leading == view.superview!.leading + 15
                view.top == view.superview!.top + 5
                view.superview!.width == view.width + 25
                view.superview!.height == view.height + 10
            }
            break
        case .Voice:
            self.voiceTimeLabel = UILabel()
            self.voiceTimeLabel.text = "\(self.message.strVoiceTime!)\""
            self.voiceTimeLabel.font = UIFont.systemFontOfSize(12)
            self.voiceImageView = UIImageView()
            self.addSubview(voiceTimeLabel)
            self.addSubview(voiceImageView)
            if message.from == .Me{
                self.voiceTimeLabel.textAlignment = NSTextAlignment.Right
                constrain(voiceTimeLabel,voiceImageView) {view1,view2 in
                    view1.top == view1.superview!.top + 5
                    view1.leading == view1.superview!.leading + 15
                    view1.width == 45
                    view1.height == 25
                    view2.top == view1.top
                    view2.leading == view1.trailing + 10
                    view2.height == view1.height
                    view2.width == 25
                    view1.superview!.width == 95
                    view1.superview!.height == view2.height + 10
                }
                self.voiceImageView.image = UIImage(named: "chat_animation_white3")
                var imgs = [UIImage]()
                imgs.append(UIImage(named: "chat_animation_white1")!)
                imgs.append(UIImage(named: "chat_animation_white2")!)
                imgs.append(UIImage(named: "chat_animation_white3")!)
                self.voiceImageView.animationImages = imgs
            }else{
                self.voiceTimeLabel.textAlignment = NSTextAlignment.Left
                constrain(voiceImageView,voiceTimeLabel) {view1,view2 in
                    view1.top == view1.superview!.top + 5
                    view1.leading == view1.superview!.leading + 15
                    view1.width == 25
                    view1.height == 25
                    view2.top == view1.top
                    view2.leading == view1.trailing + 10
                    view2.height == view1.height
                    view2.width == 45
                    view1.superview!.width == 95
                    view1.superview!.height == view2.height + 10
                }
                self.voiceImageView.image = UIImage(named: "chat_animation3")
                var imgs = [UIImage]()
                imgs.append(UIImage(named: "chat_animation1")!)
                imgs.append(UIImage(named: "chat_animation2")!)
                imgs.append(UIImage(named: "chat_animation3")!)
                self.voiceImageView.animationImages = imgs
            }
            self.voiceImageView.animationDuration = 1
            self.voiceImageView.animationRepeatCount = 0
            break
        default:
            break
        }
    }
    
    //MARK: 处理播放语音时的图片动画效果
    func beginLoadVoice(){
        self.voiceImageView.hidden = true
    }
    
    func didLoadVoice(){
        self.voiceImageView.hidden = false
        self.voiceImageView.startAnimating()
    }
    
    func stopPlay(){
        self.voiceImageView.stopAnimating()
    }

}
