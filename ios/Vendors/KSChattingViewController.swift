import UIKit
import Cartography
import CoreData

class KSChattingViewController: UIViewController{
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
    var tableView: KSChatTableView!
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
        tableView = KSChatTableView()
        tableView.dataSource = self
        view.addSubview(tableView)
        constrain(tableView,inputMessageView){ view1,view2 in
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
        let userInfo = notification.userInfo! as NSDictionary
        let animationDuration = userInfo.valueForKey(UIKeyboardAnimationDurationUserInfoKey) as! NSTimeInterval
        let keyboardEndFrame = (userInfo.valueForKey(UIKeyboardFrameEndUserInfoKey) as! NSValue).CGRectValue()
        let rectH = keyboardEndFrame.size.height
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
             tableView.scrollToBottom()
        }
    }
}
extension KSChattingViewController: UITableViewDataSource{
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
}
//MARK:
extension KSChattingViewController: NSFetchedResultsControllerDelegate{
    func controller(controller: NSFetchedResultsController, didChangeObject anObject: NSManagedObject, atIndexPath indexPath: NSIndexPath?, forChangeType type: NSFetchedResultsChangeType, newIndexPath: NSIndexPath?) {
        if type == .Insert {
            self.tableView.insertRowsAtIndexPaths([newIndexPath!], withRowAnimation: .Automatic)
        }
    }
    func controllerWillChangeContent(controller: NSFetchedResultsController) {
        self.tableView.beginUpdates()
    }
    func controllerDidChangeContent(controller: NSFetchedResultsController) {
        self.tableView.endUpdates()
    }

}
extension KSChattingViewController: KSInputMessageViewDelegate{
    func sendMessageText(text: String) {
        let message = Message.MR_createEntity()
        message.createDate = NSDate()
        message.messageData = text.dataUsingEncoding(NSUTF8StringEncoding)!
        message.createUserID = NSUserDefaults.userID!
        message.messageType = .Text
        processMessage(message)
        tableView.sendMessage(message)
    }
    
    func sendMessagePhoto(data: NSData, fileName: String){
        let message = Message.MR_createEntity()
        message.messageData = data
        message.createDate = NSDate()
        message.createUserID = NSUserDefaults.userID!
        message.messageType = .Picture
        processMessage(message)
         tableView.sendMessage(message)
    }
    func sendMessageVoice(voiceData: NSData,voiceTime: UInt8){
        let message = Message.MR_createEntity()
        message.messageData = voiceData
        message.voiceTime = NSNumber(unsignedChar: voiceTime)
        message.createDate = NSDate()
        message.createUserID = NSUserDefaults.userID!
        message.messageType = .Voice
        processMessage(message)
        tableView.sendMessage(message)
    }
    func processMessage(message: Message){
        
    }
}


