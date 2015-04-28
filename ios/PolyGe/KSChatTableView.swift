
import UIKit
import AVFoundation
class KSChatTableView: UITableView, UITableViewDataSource, UITableViewDelegate{
    var cellArray = [KSMessage]()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        self.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //红外线感应监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)
        self.estimatedRowHeight = 50
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UITableViewDataSource
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return cellArray.count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = KSMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellId")
        var curMessage = cellArray[indexPath.row]
        if indexPath.row > 0{
            curMessage.minuteOffSetStart(cellArray[indexPath.row-1].strTime, end: curMessage.strTime!)
        }else{
            curMessage.minuteOffSetStart(nil, end: curMessage.strTime!)
        }
        cell.setMessageFrame(curMessage)
        return cell
    }
    func scrollToBottom(){//显示最后一行消息
        if self.cellArray.count > 0 {
            var indexPath = NSIndexPath(forRow: self.cellArray.count - 1, inSection: 0)
            //用自动布局的话，要延迟一下才能滚到最后一行
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, Int64(Double(NSEC_PER_SEC) * 0.09)), dispatch_get_main_queue()){
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: true)
            }
        }
    }
    
    //MARK: 数据源处理
    func loadHistory(){//加载历史聊天记录...需要数据持久化处理...
        
    }
    
    func sendMessage(message: KSMessage){//新曾消息记录
        self.cellArray.append(message)
        self.reloadData()
        self.scrollToBottom()
    }
    
    //处理监听触发事件
    func sensorStateChange(notification: NSNotificationCenter){
        if UIDevice.currentDevice().proximityState == true {
            NSLog("Device is close to user")
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayAndRecord,error:nil)
        }
        else{
            NSLog("Device is not close to user")
            AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback,error:nil)
        }
    }


}
