//
//  Settings Classes.swift
//  Journal Plus
//
//  Created by Jacob Hanna on 08/07/2018.
//  Copyright © 2018 Jacob Hanna. All rights reserved.
//

import UIKit

protocol Setting{
    associatedtype T
    static var value : T {set get}
    static var last : T? {get set}
    static var key : String {get}
    static var defaultValue : T {get}
    
    static func restoreValue()
    static var backup : T? {set get}
    
    static func updated(_ newValue : T)
    
    static func reload()
    
    static func set()
}


extension Setting{
    static func updated(_ newValue : T) {}
    static func restoreValue(){
        BackUp(key).restoreValue()
    }
    static func reload(){
        if let c = backup{
            last = c
        }else{
            last = defaultValue
        }
    }
    static var value : T{
        get{
            if let last_ = last{
                return last_
            }else{
                reload()
                return last ?? defaultValue
            }
        }
        set{
            last = newValue
            backup = newValue
            updated(newValue)
        }
    }
    
    static func set(){
        let arr = self.value
        self.value = arr
    }
}

protocol KeyedSetting : Setting{
}
extension KeyedSetting{
    static var backup : T?{
        set{
            if let v = newValue{
                BackUp(key).set(v)
            }else{
                BackUp(key).restoreValue()
            }
            
        }
        get{
            return BackUp(key).get()
        }
    }
}
protocol CodableSetting : Setting where T : Codable {
}
extension CodableSetting{
    static var backup : T?{
        set{
            if let v = newValue{
                BackUp(key).set(v)
            }else{
                BackUp(key).restoreValue()
            }
            
        }
        get{
            return BackUp(key).get()
        }
    }
}



class DateStyle : CodableSetting{
    
    static var last: DateFormatter.Style? = nil
    static let key = "dateWrittenTypeBackUpKey"
    static let defaultValue = DateFormatter.Style.short
    static let styles : [DateFormatter.Style] = [.short,.medium,.long,.full]
}



/*
 class Indicator: KeyedSetting{
     static var last: Bool? = nil
     static let key = "expandedIndicatorKey"
     static let defaultValue = true
 }
 */
