//
//  KSChattingViewController.swift
//  PolyGe
//
//  Created by king on 15/4/19.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
import JSQMessagesViewController
class KSChattingViewController: JSQMessagesViewController {
    let module = KSChattingModule()
    override func viewDidLoad() {
        super.viewDidLoad()
        senderId = RuntimeStatus.instance.user.objID
        senderDisplayName = RuntimeStatus.instance.user.userName
        showLoadEarlierMessagesHeader = true
        inputToolbar

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
    
    //MARK: JSQMessagesViewController method overrides
    override func didPressSendButton(button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: NSDate!) {
        JSQSystemSoundPlayer.jsq_playMessageReceivedSound()
        let message = JSQMessage(senderId: senderId, senderDisplayName: senderDisplayName, date: date, text: text)
        module.messages.addObject(message)
        finishSendingMessageAnimated(true)
    }
    override func didPressAccessoryButton(sender: UIButton!) {
//        <#code#>
    }
    
    //MARK: JSQMessagesCollectionViewDataSource
    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return module.messages.count
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageData! {
        return module.messages[indexPath.item] as! JSQMessageData
    }
    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAtIndexPath: indexPath) as! JSQMessagesCollectionViewCell
        let message = module.messages[indexPath.item] as! JSQMessageData

        if !message.isMediaMessage() {
            if message.senderId() == senderId {
                cell.textView.textColor = UIColor.blackColor()
            }else{
                cell.textView.textColor = UIColor.whiteColor()
                
            }
            cell.textView.linkTextAttributes = [NSForegroundColorAttributeName : cell.textView.textColor,
                NSUnderlineStyleAttributeName : "\(NSUnderlineStyle.StyleSingle)"]
        }
       
        return cell

    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = self.collectionView(collectionView, messageDataForItemAtIndexPath: indexPath)
        if message.senderId() == senderId {
            return module.outgoingBubbleImageData;
        }else{
            return module.incomingBubbleImageData;

        }
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAtIndexPath indexPath: NSIndexPath!) -> JSQMessageAvatarImageDataSource! {
        let message = self.collectionView(collectionView, messageDataForItemAtIndexPath: indexPath)
        return module.avatars[message.senderId()]

    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, attributedTextForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> NSAttributedString! {
        if indexPath.item % 3 == 0 {
            let message = module.messages[indexPath.item]
            return JSQMessagesTimestampFormatter.sharedFormatter().attributedTimestampForDate(message.date)
        }
        
        return nil;
    }
    //MARK: - JSQMessages collection view flow layout delegate
    
    //MARK: - Adjusting cell label heights
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForCellTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        if indexPath.item % 3 == 0 {
            return kJSQMessagesCollectionViewCellLabelHeightDefault
        }
        return 0.0
    }
    override func collectionView(collectionView: JSQMessagesCollectionView!, layout collectionViewLayout: JSQMessagesCollectionViewFlowLayout!, heightForMessageBubbleTopLabelAtIndexPath indexPath: NSIndexPath!) -> CGFloat {
        let currentMessage = module.messages[indexPath.row]
        if currentMessage.senderId() == senderId {
            return 0.0
        }
        if indexPath.item - 1 > 0 {
            let previousMessage = module.messages[indexPath.row - 1]
            if previousMessage.senderId() == currentMessage.senderId() {
                return 0.0
            }
        }
        return kJSQMessagesCollectionViewCellLabelHeightDefault
    }
    
    
}
