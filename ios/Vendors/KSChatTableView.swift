
import UIKit
import AVFoundation
import CoreData
import Async

class KSChatTableView: UITableView, UITableViewDataSource, UITableViewDelegate,NSFetchedResultsControllerDelegate{
    lazy var fetchedResultsController: NSFetchedResultsController = {
        var request = Message.MR_requestAllSortedBy("createDate", ascending: true)
        let count = Message.MR_numberOfEntities()
        if count.integerValue > 100 {
            request.fetchOffset = count.integerValue - 100
        }
        let frc = Message.MR_fetchController(request, delegate: self, useFileCache: true, groupedBy: nil, inContext:NSManagedObjectContext.MR_defaultContext())
        do{
            try frc.performFetch()
        }catch _{
            
        }
        return frc
    }()
    override init(frame: CGRect, style: UITableViewStyle) {
        super.init(frame: frame, style: style)
        self.delegate = self
        self.dataSource = self
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
    
    //MARK: UITableViewDataSource
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return self.fetchedResultsController.sections!.count
    }

    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.fetchedResultsController.sections![section].numberOfObjects
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell{
        let cell = KSMessageCell(style: UITableViewCellStyle.Default, reuseIdentifier: "CellId")
        let curMessage = self.fetchedResultsController.objectAtIndexPath(indexPath) as! Message
        if indexPath.row > 0{
            curMessage.minuteOffSetStart((self.fetchedResultsController.objectAtIndexPath(NSIndexPath(forRow: indexPath.row-1, inSection: indexPath.section)) as! Message).createDate, end: curMessage.createDate)
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
                let indexPath = NSIndexPath(forRow: self.tableView(self, numberOfRowsInSection: 0)-1, inSection: 0)
                self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                 Async.main(after: 0.01){
                    self.scrollToRowAtIndexPath(indexPath, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
                }
               
            }
        }
    }
    
    func sendMessage(message: Message){//新曾消息记录
        NSManagedObjectContext.MR_defaultContext().MR_saveToPersistentStoreAndWait()
        self.scrollToBottom()
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
    //MARK: NSFetchedResultsControllerDelegate
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert {
            insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        beginUpdates()
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        endUpdates()
    }

}
