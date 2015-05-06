
import UIKit

//定义ui样式
let kScreenBounds = UIScreen.mainScreen().bounds
let kCornerRadius: CGFloat = 6
let kBorderWidth: CGFloat = 0.5
let kBorderColor = UIColor.lightGrayColor().CGColor

let kTimeLabelTextColor = UIColor.grayColor()// 时间字体颜色
let kChatTimeFont = UIFont.systemFontOfSize(11)//时间字体
let kUserDefault = 00001
let kUserPlaceHolderImage = UIImage(named: "User")
let kManagedContext = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext!
