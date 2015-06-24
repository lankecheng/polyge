//
//  KSString.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
extension String {
    static let phoneRegex = NSPredicate(format: "SELF MATCHES %@", "^1[34578]\\d{9}$")
    static let  emailRegex = NSPredicate(format: "SELF MATCHES %@", "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}")
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
    func checkMobileNumble() -> Bool {
        return String.phoneRegex.evaluateWithObject(self)
    }
    func checkEmail() -> Bool {
        return String.emailRegex.evaluateWithObject(self)
    }
}