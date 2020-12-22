//
//  List.swift
//  DoneTracker
//
//  Created by Jacob Hanna on 22/12/2020.
//

import UIKit
import SwiftUI

class Lists: CodableSetting{
    static var last: [doneList]? = nil
    static let key = "savedListsKey"
    static let defaultValue: [doneList] = []
    
    static var selectedIndex = 0
    static var selectedList : doneList{
        get{
            return Lists.value[Lists.selectedIndex]
        }
        set{
            Lists.value[Lists.selectedIndex] = newValue
            Lists.set()
        }
    }
    
    static func newList (_ list : doneList = doneList()){
        Lists.value.append(list)
        Lists.set()
    }
    
    static var props : FormProperties{
        let newList = FormCell(type: .StringTitle(), title: "Create New List", tap:  {
            Lists.newList()
            FormVC.top?.showForm({Lists.props(of: Lists.value.count - 1)})
        })
        
        
        let settings = FormCell(type: .StringTitle(), title: "Setting", tap:  {
            print("not yet here....")
        })
        
        var i = -1
        let listCells = Lists.value.map({ (l) -> FormCell in
            i += 1
            return FormCell(type: .StringTitle(), title: l.name, tap:  {
                FormVC.top?.showForm({Lists.props(of: i)})
            })
        })
        
        return FormProperties(title: "Lists", cells: [newList, settings] + listCells, button: .done)
    }
    
    static func props (of index : Int) -> FormProperties{
        let name = FormCell(type: .StringInput, title: "Name") { (inp) in
            if let s = inp as? String{
                Lists.value[index].name = s
                Lists.set()
            }
        } get: { () -> Any in
            return Lists.value[index].name
        }
        
        let color = FormCell(type: .ColorInput, title: "Color") { (inp) in
            if let c = inp as? Color{
                Lists.value[index].color = UIColor(c)
                Lists.set()
            }
        } get: { () -> Any in
            return Color(Lists.value[index].color)
        }
        
        let doneImageName = FormCell(type: .StringInput, title: "Done Image") { (inp) in
            if let s = inp as? String{
                Lists.value[index].doneImageName = s
                Lists.set()
            }
        } get: { () -> Any in
            return Lists.value[index].doneImageName
        }
        
        let undoneImageName = FormCell(type: .StringInput, title: "Undone Image") { (inp) in
            if let s = inp as? String{
                Lists.value[index].undoneImageName = s
                Lists.set()
            }
        } get: { () -> Any in
            return Lists.value[index].undoneImageName
        }
        
        let select = FormCell(type: .StringTitle(), title: "Select this list", tap:  {
            Lists.selectedIndex = index
        })
        
        return FormProperties(title: "List", cells: [name,color,doneImageName,undoneImageName, select], button: .done)


    }
    
}


class doneList : Codable{
    var name : String
    var days : [Int:[Int:[Int:Bool]]]
    var color : UIColor
    var doneImageName : String
    var undoneImageName : String
    
    init() {
        name = "New List"
        days = [:]
        color = UIColor.label
        doneImageName = "checkmark.circle"
        undoneImageName = "circle"
    }
    
    subscript(day : Day) -> Bool{
        get{
            if days[day.y] != nil{
                if days[day.y]?[day.m] != nil{
                    return days[day.y]?[day.m]?[day.d] ?? false
                }
            }
            return false
        }
        set{
            if newValue{
                addDay(day)
            }else{
                removeDay(day)
            }
            Lists.set()
        }
        
    }
    
    
    
    func addDay(_ day : Day){
        
        if days[day.y] == nil{
            days[day.y] = [:]
        }
        if days[day.y]?[day.m] == nil{
            days[day.y]?[day.m] = [:]
        }
        days[day.y]?[day.m]?[day.d] = true
    }
    
    func removeDay(_ day: Day){
        if days[day.y] != nil{
            if days[day.y]?[day.m] != nil{
                days[day.y]?[day.m]?.removeValue(forKey: day.d)
            }
        }
        
    }
    
    enum CodingKeys: String, CodingKey {
        case name
        case days
        case color
        case doneImageName
        case undoneImageName
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(name, forKey: .name)
        try container.encode(days, forKey: .days)
        try container.encode(color.hexCode, forKey: .color)
        try container.encode(doneImageName, forKey: .doneImageName)
        try container.encode(undoneImageName, forKey: .undoneImageName)
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        name = try values.decode(String.self, forKey: .name)
        days = try values.decode([Int:[Int:[Int:Bool]]].self, forKey: .days)
        color = UIColor(hex: try values.decode(String.self, forKey: .color)) ?? UIColor.label
        doneImageName = try values.decode(String.self, forKey: .doneImageName)
        undoneImageName = try values.decode(String.self, forKey: .undoneImageName)
    }
}


extension UIColor{
    public convenience init?(hex: String) {
            let r, g, b, a: CGFloat

            let hexColor = hex

            if hexColor.count == 8 {
                let scanner = Scanner(string: hexColor)
                var hexNumber: UInt64 = 0

                if scanner.scanHexInt64(&hexNumber) {
                    r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
                    g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
                    b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
                    a = CGFloat(hexNumber & 0x000000ff) / 255

                    self.init(red: r, green: g, blue: b, alpha: a)
                    return
                }
            }

            return nil
        }
    
    var hexCode : String {
            var r:CGFloat = 0
            var g:CGFloat = 0
            var b:CGFloat = 0
            var a:CGFloat = 0
            
            getRed(&r, green: &g, blue: &b, alpha: &a)
            
            let rgb:Int = (Int)(r*255)<<16 | (Int)(g*255)<<8 | (Int)(b*255)<<0
            
            return String(format:"#%06x", rgb)
        }
}
