
import UIKit
import AVFoundation
import CoreData
import Async
import AlecrimCoreData

class KSChatTableView: UITableView, UITableViewDataSource, UITableViewDelegate{
    lazy var fetchedResultsController: FetchedResultsController<Message> = {
        var query = dataContext.messages.orderByAscending("createDate")
        let count = query.count()
        if count > 100 {
            query = query.skip(count-100)
        }
        let frc = query.toFetchedResultsController()
        frc.bindToTableView(self)
        return frc
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.delegate = self
        self.dataSource = self
        self.keyboardDismissMode = UIScrollViewKeyboardDismissMode.OnDrag
        self.separatorStyle = UITableViewCellSeparatorStyle.None
        
        //红外线感应监听
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "sensorStateChange:", name: UIDeviceProximityStateDidChangeNotification, object: nil)
        self.estimatedRowHeight = 50
        self.scrollToBottom()
    }
    
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
    }
    
    required init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections.count
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.fetchedResultsController.sections[section].numberOfEntities
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        var cell = KSMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellId")
        var curMessage = self.fetchedResultsController.entityAtIndexPath(indexPath)
        if indexPath.row > 0{
            curMessage.minuteOffSetStart(self.fetchedResultsController.entityAtIndexPath(NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)).createDate, end: curMessage.createDate)
        }else{
            curMessage.minuteOffSetStart(nil, end: curMessage.createDate)
        }
        cell.setMessageFrame(curMessage)
        return cell
    }
    func scrollToBottom(){//显示最后一行消息
        //用自动布局的话，要延迟一下才能滚到最后一行,而且还要延迟两次.
        Async.main(after: 0.01){
            if self.contentSize.height > self.frame.height {
                var indexPath = NSIndexPath(forRow: self.tableView(self, numberOfRowsInSection: 0)-1, inSection: 0)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                 Async.main(after: 0.01){
                    self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
               
            }
        }
    }
    
    func sendMessage(message: Message){//新曾消息记录
        let (success, error) = dataContext.save()
        if !success {
            // Replace this implementation with code to handle the error appropriately.
            NSLog("Unresolved error \(error), \(error?.userInfo)")
        }
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
