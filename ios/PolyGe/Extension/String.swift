//
//  KSString.swift
//  PolyGe
//
//  Created by king on 15/4/17.
//  Copyright (c) 2015年 king. All rights reserved.
//

import Foundation
extension String {
    subscript (i: Int) -> Character {
        return self[advance(self.startIndex, i)]
    }
    
    subscript (i: Int) -> String {
        return String(self[i] as Character)
    }
    
    subscript (r: Range<Int>) -> String {
        return substringWithRange(Range(start: advance(startIndex, r.startIndex), end: advance(startIndex, r.endIndex)))
    }
}