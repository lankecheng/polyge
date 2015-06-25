
import UIKit

//定义ui样式
let kScreenBounds = UIScreen.mainScreen().bounds
let kCornerRadius: CGFloat = 6
let kBorderWidth: CGFloat = 0.5
let kBorderColor = UIColor.lightGrayColor().CGColor

let kTimeLabelTextColor = UIColor.grayColor()// 时间字体颜色
let kChatTimeFont = UIFont.systemFontOfSize(11)//时间字体
let kUserPlaceHolderImage = UIImage(named: "User")

func LocalizedString(key: String, comment: String = "") -> String
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

