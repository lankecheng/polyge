
import UIKit
import CoreStore
//屏幕相关
let kScreenBounds = UIScreen.mainScreen().bounds
let SCREEN_WIDTH = kScreenBounds.width
let SCREEN_HEIGHT = kScreenBounds.height
let SCREEN_SCALE = UIScreen.mainScreen().scale
let SCREEN_RATIO = SCREEN_WIDTH/320.0
//定义ui样式
let kCornerRadius: CGFloat = 6
let kBorderWidth: CGFloat = 0.5
let kBorderColor = UIColor.lightGrayColor().CGColor

let kTimeLabelTextColor = UIColor.grayColor()// 时间字体颜色
let kChatTimeFont = UIFont.systemFontOfSize(11)//时间字体
let kUserPlaceHolderImage = UIImage(named: "User")

func KSLocalizedString(key: String, comment: String = "") -> String
{
    return NSLocalizedString(key, comment: comment)
}
/// Get App name
let APP_NAME: String = NSBundle.mainBundle().infoDictionary!["CFBundleDisplayName"] as! String

/// Get App build
let APP_BUILD: String = NSBundle.mainBundle().infoDictionary!["CFBundleVersion"] as! String

/// Get App version
let APP_VERSION: String = NSBundle.mainBundle().infoDictionary!["CFBundleShortVersionString"] as! String
let APP_DELEGATE = UIApplication.sharedApplication().delegate as! AppDelegate
let APPBundleIdentifier = NSBundle.mainBundle().infoDictionary!["CFBundleIdentifier"] as! String


