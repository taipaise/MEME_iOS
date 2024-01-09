//
//  NSObject+.swift
//  MEME
//
//  Created by 이동현 on 1/9/24.
//

import Foundation

public extension NSObject {
    
    var className: String {
        return String(describing: type(of: self))
    }
    
    class var className: String {
        return String(describing: self)
    }
    
    var bundle: Bundle {
        return Bundle(for: type(of: self))
    }
    
    class var bundle: Bundle {
        return Bundle(for: self)
    }
    
}
