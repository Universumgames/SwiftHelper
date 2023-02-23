//
//  Date.swift
//  Moody
//
//  Created by Tom Arlt on 19.01.22.
//

import Foundation

public extension Date {
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

    static func from(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        let gregorianCalendar = NSCalendar(calendarIdentifier: .gregorian)!

        var dateComponents = DateComponents()
        dateComponents.year = year
        dateComponents.month = month
        dateComponents.day = day
        dateComponents.hour = hour
        dateComponents.minute = minute
        dateComponents.second = second

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
        get {
            let comp = calendar.dateComponents([.hour, .minute, .second], from: self)
            return Time(hour: comp.hour ?? 0, minute: comp.minute ?? 0, second: comp.second ?? 0)
        }
        set {
            self = Date.from(year: year, month: month, day: day, hour: newValue.hour, minute: newValue.minute, second: newValue.second)
        }
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

    func startOfDay() -> Date {
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

public struct SmallDateComponents: Comparable {
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
        year = components.year
        month = components.month
        day = components.day
    }
}

public extension Formatter {
    static var customISO8601DateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        return formatter
    }()

    static let yyyyMMdd: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.timeZone = TimeZone(secondsFromGMT: 0)
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()
}

public extension JSONDecoder.DateDecodingStrategy {
    static var iso8601WithFractionalSeconds = custom { decoder in
        let dateStr = try decoder.singleValueContainer().decode(String.self)
        let customIsoFormatter = Formatter.customISO8601DateFormatter
        if let date = customIsoFormatter.date(from: dateStr) {
            return date
        }
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: decoder.codingPath,
                                  debugDescription: "Invalid date"))
    }
}

public extension JSONEncoder.DateEncodingStrategy {
    static var iso8601WithFractionalSeconds = custom { date, encoder in
        let dateStr = Formatter.customISO8601DateFormatter.string(from: date)
        var singleValueEnc = encoder.singleValueContainer()
        try singleValueEnc.encode(dateStr)
    }
}
