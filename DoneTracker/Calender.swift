//
//  Calender.swift
//  Journal Plus
//
//  Created by Jacob Hanna on 14/07/2020.
//  Copyright © 2020 Jacob Hanna. All rights reserved.
//

import UIKit

extension DateFormatter.Style : Codable{
    enum CodingKeys: String, CodingKey
    {
        case raw
    }
    public func encode(to encoder: Encoder) throws
    {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(self.rawValue, forKey: .raw)

    }
    public init(from decoder: Decoder) throws
    {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        self = DateFormatter.Style(rawValue: try values.decode(UInt.self, forKey: .raw)) ?? DateFormatter.Style.short
    }
}

extension Date{
    var minute : Int{
        return NSCalendar.current.component(.minute, from: self)
    }
    var hour : Int{
        return NSCalendar.current.component(.hour, from: self)
    }
    var day : Int{
        return NSCalendar.current.component(.day, from: self)
    }
    var month : Int{
        return NSCalendar.current.component(.month, from: self)
    }
    var year : Int{
        return NSCalendar.current.component(.year, from: self)
    }
    var weekday : Int{
        return NSCalendar.current.component(.weekday, from: self)
    }
    var code : String{
        let formatter = DateFormatter()
        formatter.dateFormat = "D"
        let day = formatter.string(from: self)
        formatter.dateFormat = "yyyy"
        return day + formatter.string(from: self)
    }
    
    var toDay : Day{
        return Day(self)
    }
    
    var dayStart : Date{
        let calender = Calendar.current
        let comp = DateComponents(year:year, month: month,day: day,hour: 0,minute: 0,second: 0)
        return calender.date(from: comp)!
    }

    var toString : String{
        let formatter = DateFormatter()
        formatter.dateStyle = DateStyle.value
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }
}

class Day: Comparable, CustomStringConvertible, Codable{
    var description: String{
        return "\(y)/\(m)/\(d)"
    }
    
    
    static func < (lhs: Day, rhs: Day) -> Bool {
        return lhs.y == rhs.y ? (lhs.m == rhs.m ? lhs.d < rhs.d : lhs.m < rhs.m) : lhs.y < rhs.y
    }
    
    static func == (lhs: Day, rhs: Day) -> Bool {
        return lhs.y == rhs.y && lhs.m == rhs.m && lhs.d == rhs.d
    }
    
    var y = -1
    var m = -1
    var d = -1
    
    init(_ y : Int , _ m : Int , _ d : Int) {
        if (d <= Day.dayInMonth(y,m) && m >= 1 && m <= 12){
            self.y = y
            self.m = m
            self.d = d
        }
    }
    
    
    init (_ day : Day){
        self.y = day.y
        self.m = day.m
        self.d = day.d
    }
    
    init (_ date : Date = Date()){
        self.y = date.year
        self.m = date.month
        self.d = date.day
    }
    
    var valid : Bool{
        return y != -1
    }
    
    var toDate : Date{
        let components = DateComponents(year:y,month:m,day:d)
        return Calendar.current.date(from: components)!
    }
    
    var toString: String{
        return toDate.toString
    }
    
    var weekday : Int{
        return toDate.weekday
    }
    
    var enabled : Bool{
        return self <= Day()
    }
    
    var next : Day{
        let nextDay = Day(self)
        nextDay.d += 1
        if (nextDay.d > Day.dayInMonth(nextDay.y,nextDay.m)){
            nextDay.d = 1
            nextDay.m += 1
            if (nextDay.m > 12){
                nextDay.m = 1
                nextDay.y += 1
            }
        }
        return nextDay
    }
    
    var prev : Day{
        let nextDay = Day(self)
        nextDay.d -= 1
        if (nextDay.d < 1){
            nextDay.m -= 1
            if (nextDay.m < 1){
                nextDay.m = 12
                nextDay.y -= 1
            }
            nextDay.d = Day.dayInMonth(nextDay.y,nextDay.m)
        }
        return nextDay
    }
    
    var split : (Int,Int,Int){
        return (y,m,d)
    }
    
    static func leap (_ year : Int) -> Bool{
        return (year % 400 == 0 || ( year % 4 == 0 && year % 100 != 0))
    }
    static func dayInMonth (_ year : Int, _ month : Int) -> Int{
        if (month < 1 || month > 12){
            return 0
        }
        if (month == 2){
            return Day.leap(year) ? 29 : 28
        }
        return month == 1 || month == 3 || month == 5 || month == 7 || month == 8 || month == 10 || month == 12 ? 31 : 30
    }
    
    enum CodingKeys: String, CodingKey {
        case day
        case month
        case year
        case hour
        case minute
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(d, forKey: .day)
        try container.encode(m, forKey: .month)
        try container.encode(y, forKey: .year)
        
    }
    
    required init(from decoder: Decoder) throws {
        let values = try decoder.container(keyedBy: CodingKeys.self)
        d = try values.decode(Int.self, forKey: .day)
        m = try values.decode(Int.self, forKey: .month)
        y = try values.decode(Int.self, forKey: .year)
    }
}



class Calender{
    
    static let dayTitles = ["Sun", "Mon", "Tue","Wed","Thu","Fri","Sat"]
    static let miniDayTitles = ["S", "M", "T","W","T","F","S"]
    static let months = ["January", "February", "March", "April", "May", "June", "July", "August", "September", "October", "November", "December"]
    
    var month : Int = Day().m
    var year : Int = Day().y
    
    var start = 0
    var end = 0
    
    var days : [Day] = []
    
    let dayRows : Int = 6
    var dayCount : Int {
        return dayRows * 7
    }
    
    subscript(row: Int, column: Int) -> Day{
        get{
            return days[row * 7 + column]
        }
    }
    
    public convenience init(month: Int, year: Int) {
        self.init()
        set(month: month, year: year)
    }
    
    init() {
        days = [Day](repeating: Day(), count: dayCount)
        getDates()
    }
    
    func nextMonth(){
        month+=1
        if month == 13{
            month = 1
            year+=1
        }
        getDates()
    }
    
    func prevMonth(){
        month-=1
        if month == 0{
            month = 12
            year-=1
        }
        getDates()
    }
    
    func next() -> (Int,Int) {
        var m = month+1
        var y = year
        if m == 13{
            m = 1
            y+=1
        }
        return (m,y)
    }
    
    func prev() -> (Int,Int){
        var m = month-1
        var y = year
        if m == 0{
            m = 12
            y-=1
        }
        return (m,y)
    }
    
    func set (month : Int? = nil, year: Int? = nil){
        let m = month != nil ? month! : -1
        if(m>=1 && m<=12){
            self.month = month!
        }
        self.year = year != nil ? year! : self.year
        getDates()
    }
    
    func getDates(){
        var first = Day(year,month,1)
        var day = first
        start = day.weekday - 1
        days[day.weekday - 1] = day
        day = day.prev
        while(day.weekday != 7){
            days[day.weekday - 1] = day
            day = day.prev
        }
        var ended = false
        for i in first.weekday ..< dayCount{
            first = first.next
            days[i] = first
            if(first.m != month && !ended){
                end = i-1;
                ended = true
            }
        }
    }
    
}
