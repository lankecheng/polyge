//: Playground - noun: a place where people can play
//: Playground - noun: a place where people can play

import UIKit

var i : Int64 = 0x1
var i1 = i.bigEndian
let data = NSMutableData()
data.appendBytes(&i1, length: 8)
data.debugDescription

let data1 = NSMutableData()
data1.appendData(data)


let str = "123456789"
str.startIndex.advancedBy(7)










