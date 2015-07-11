//
//  KSStoryboard.swift
//  PolyGe
//
//  Created by king on 15/4/16.
//  Copyright (c) 2015年 king. All rights reserved.
//

import UIKit
struct KSStoryboard {
    struct XIBIdentifiers {
        static let personHeaderView = "PersonHeaderView"
        static let KSPersonViewController = "KSPersonViewController"
//        static let listViewNavigationController = "listViewNavigationController"
    }
    
    struct TableViewCellIdentifiers {
        static let cell = "cell"
        static let languageCell = "languageCell"
        static let personCell = "personCell"
        static let friendCell = "friendCell"
        static let messageCell = "messageCell"
        static let subtitleCell = "subtitleCell"
        static let reportOrSwitchCell = "reportOrSwitchCell"
        static let playAudioCell = "playAudioCell"
        static let searchCell = "searchCell"
        static let lastMessageCell = "lastMessageCell"

    }
    
    struct SegueIdentifiers {
//        static let newListDocument = "newListDocument"
//        static let showListDocument = "showListDocument"
//        static let showListDocumentFromUserActivity = "showListDocumentFromUserActivity"
    }
    static var mainViewController: UITabBarController {
        get{
            return UIStoryboard(name: "Main", bundle: nil).instantiateInitialViewController() as! UITabBarController
        }
    }
    static var loginNavigationController:UINavigationController {
        get{
            return UIStoryboard(name: "Login", bundle: nil).instantiateInitialViewController() as! UINavigationController
        }
    }
    static var loginViewController:UIViewController {
        get{
          return UIStoryboard(name: "Login", bundle: nil).instantiateViewControllerWithIdentifier("login")
        }
    }
}
