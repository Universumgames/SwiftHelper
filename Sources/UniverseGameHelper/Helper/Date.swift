//
//  Date.swift
//  Moody
//
//  Created by Tom Arlt on 19.01.22.
//

import Foundation

extension Date {
    func equalsCalendarDate(compare: Date) -> Bool {
        return Calendar.current.dateComponents([.day, .year, .month], from: self) == Calendar.current.dateComponents([.day, .year, .month], from: compare)
    }

    func isInCalendarRange(date1: Date, date2: Date) -> Bool {
        let clip1 = SmallDateComponents(Calendar.current.dateComponents([.day, .year, .month], from: date1))
        let clip2 = SmallDateComponents(Calendar.current.dateComponents([.day, .year, .month], from: date2))
        let cur = SmallDateComponents(Calendar.current.dateComponents([.day, .year, .month], from: self))
        return cur >= clip1 && cur <= clip2
    }

    static func getDaysInRange(date1: Date, date2: Date) -> Array<Date> {
        var list: Array<Date> = []
        let components = Calendar.current.dateComponents([.day], from: date1, to: date2)
        let numberOfDays = components.day ?? 1
        for i in 1 ... numberOfDays {
            let nextDate = Calendar.current.date(byAdding: .day, value: i, to: date1)!
            list.append(nextDate)
        }
        return list
    }

    static func getMonthsInRange(date1: Date, date2: Date) -> Array<Date> {
        var list: Array<Date> = []
        let components = Calendar.current.dateComponents([.month], from: date1, to: date2)
        let numberOfMonths = components.month ?? 1
        for i in 1 ... numberOfMonths {
            let nextDate = Calendar.current.date(byAdding: .month, value: i, to: date1)!
            list.append(nextDate)
        }
        return list
    }

    func startOfMonth() -> Date {
        return Calendar.current.date(from: Calendar.current.dateComponents([.year, .month], from: Calendar.current.startOfDay(for: self)))!
    }

    func endOfMonth() -> Date {
        return Calendar.current.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth())!
    }

    static func from(year: Int, month: Int, day: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day

        let date = gregorianCalendar.date(from: dateComponents)!
        return date
    }

    static func getDaysOfMonth(year: Int, month: Int) -> Int {
        return from(year: year, month: month, day: 1).endOfMonth().day - 1
    }

    var calendar: Calendar { Calendar(identifier: .gregorian) }

    var weekday: Int {
        (calendar.component(.weekday, from: self) - calendar.firstWeekday + 7) % 7
    }

    struct Time {
        let hour: Int
        let minute: Int
        let second: Int
    }

    var time: Time {
        let comp = calendar.dateComponents([.hour, .minute, .second], from: self)
        return Time(hour: comp.hour ?? 0, minute: comp.minute ?? 0, second: comp.second ?? 0)
    }

    static let totalSecondsDay = 24 * 60 * 60

    var dayPercent: Double {
        let time = self.time
        let totalThis = time.hour * 60 * 60 + time.minute * 60 + time.second
        return Double(totalThis) / Double(Date.totalSecondsDay)
    }

    var year: Int {
        calendar.component(.year, from: self)
    }

    var month: Int {
        calendar.component(.month, from: self)
    }

    var day: Int {
        calendar.component(.day, from: self)
    }

    public func startOfDay() -> Date {
        return calendar.startOfDay(for: self)
    }

    func endOfDay() -> Date {
        return calendar.date(byAdding: .day, value: 1, to: startOfDay())!
    }

    func startOfYear() -> Date {
        return Date.from(year: year, month: 1, day: 1).startOfDay()
    }

    func endOfYear() -> Date {
        return Date.from(year: year, month: 12, day: 31).endOfDay()
    }
}

struct SmallDateComponents: Comparable{
    let year: Int?
    let month: Int?
    let day: Int?
    
    public static func < (lhs: SmallDateComponents, rhs: SmallDateComponents) -> Bool {
        return lhs.year ?? 0 < rhs.year ?? 0 && lhs.month ?? 0 < rhs.month ?? 0 && lhs.day ?? 0 < rhs.day ?? 0
    }

    public static func > (lhs: SmallDateComponents, rhs: SmallDateComponents) -> Bool {
        return lhs.year ?? 0 > rhs.year ?? 0 && lhs.month ?? 0 > rhs.month ?? 0 && lhs.day ?? 0 > rhs.day ?? 0
    }
    
    init(_ components: DateComponents) {
        self.year = components.year
        self.month = components.month
        self.day = components.day
    }
}
