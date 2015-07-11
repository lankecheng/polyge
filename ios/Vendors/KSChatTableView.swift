
import UIKit
import AVFoundation
import CoreData
import GCDKit
class KSChatTableView: UITableView, UITableViewDelegate{
   
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //红外线感应监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)
        self.estimatedRowHeight = 50
        self.scrollToBottom()

    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func scrollToBottom(){//显示最后一行消息
        //用自动布局的话，要延迟一下才能滚到最后一行,而且还要延迟两次.
        GCDQueue.Main.after(0.01){
            if self.contentSize.height > self.frame.height {
                let indexPath = NSIndexPath(forRow: self.numberOfRowsInSection(0) - 1, inSection: 0)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                 GCDQueue.Main.after(0.01){
                    self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
               
            }
        }
    }

    
    //处理监听触发事件
    func sensorStateChange(notification: NSNotificationCenter){
        if UIDevice.currentDevice().proximityState == true {
            NSLog("Device is close to user")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord)
            } catch _ {
            }
        }
        else{
            NSLog("Device is not close to user")
            do {
                try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            } catch _ {
            }
        }
    }
  
}
