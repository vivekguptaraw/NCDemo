//
//  DateModel.swift
//  NCDemo
//
//  Created by Vivek Gupta on 29/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation

import UIKit

public enum MonthType { case previous, current, next }
public enum MonthName { case oct, nov, dec, jan, feb, mar, apr, may }


final class DateModel: NSObject {
    
    // Type properties
    static let dayCountPerRow = 7
    static let maxCellCount   = 42
    
    // Week text
    //var weeks: (String, String, String, String, String, String, String) = ("SUN", "MON", "TUE", "WED", "THU", "FRI", "SAT")
    var weeks: (String, String, String, String, String, String, String) = ("S", "M", "T", "W", "T", "F", "S")
    
    enum WeekType: String {
        case monday, tuesday, wednesday, thursday, friday, saturday, sunday
        
        init?(_ indexPath: IndexPath) {
            let firstWeekday = Calendar.current.firstWeekday
            switch indexPath.row % 7 {
            case (8 -  firstWeekday) % 7:  self = .sunday
            case (9 -  firstWeekday) % 7:  self = .monday
            case (10 - firstWeekday) % 7:  self = .tuesday
            case (11 - firstWeekday) % 7:  self = .wednesday
            case (12 - firstWeekday) % 7:  self = .thursday
            case (13 - firstWeekday) % 7:  self = .friday
            case (14 - firstWeekday) % 7:  self = .saturday
            default: return nil
            }
        }
    }
    
    enum SelectionMode { case single, multiple, sequence, none }
    var selectionMode: SelectionMode = .single
    
    struct SequenceDates { var start, end: Date? }
    lazy var sequenceDates: SequenceDates = .init(start: nil, end: nil)
    
    // Fileprivate properties
    fileprivate var currentDates: [Date] = []
    fileprivate var selectedDates: [Date: Bool] = [:]
    fileprivate var highlightedDates: [Date] = []
    fileprivate var currentDate: Date = .init()
    
    // MARK: - Initialization
    
    override init() {
        super.init()
        setup()
    }
    
    // MARK: - Internal Methods -
    
    func cellCount(in month: MonthType) -> Int {
        if let weeksRange = calendar.range(of: .weekOfMonth, in: .month, for: atBeginning(of: month)) {
            let count = weeksRange.upperBound - weeksRange.lowerBound
            return count * DateModel.dayCountPerRow
        }
        return 0
    }
    
    func indexAtBeginning(in month: MonthType) -> Int? {
        if let index = calendar.ordinality(of: .day, in: .weekOfMonth, for: atBeginning(of: month)) {
            return index - 1
        }
        return nil
    }
    
    func indexAtEnd(in month: MonthType) -> Int? {
        if let rangeDays = calendar.range(of: .day, in: .month, for: atBeginning(of: month)), let beginning = indexAtBeginning(in: month) {
            let count = rangeDays.upperBound - rangeDays.lowerBound
            return count + beginning - 1
        }
        return nil
    }
    
    func customIndexAtBeginning(in month: MonthType) -> Int? {
        if let index = calendar.ordinality(of: .day, in: .weekOfMonth, for: atBeginning(of: month)) {
            return index - 1
        }
        return nil
    }
    
    func customIndexAtEnd(in month: MonthType) -> Int? {
        if let rangeDays = calendar.range(of: .day, in: .month, for: atBeginning(of: month)), let beginning = indexAtBeginning(in: month) {
            let count = rangeDays.upperBound - rangeDays.lowerBound
            return count + beginning - 1
        }
        return nil
    }
    
    
    func dayString(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool) -> String {
        if isHidden && isOtherMonth(at: indexPath) {
            return ""
        }
        let formatter: DateFormatter = .init()
        formatter.dateFormat = "d"
        return formatter.string(from: currentDates[indexPath.row])
    }
    
    func currentDate(at indexPath: IndexPath, isHiddenOtherMonth isHidden: Bool) -> Date {
        return currentDates[indexPath.row]
    }
    
    
    func isOtherMonth(at indexPath: IndexPath) -> Bool {
        if let beginning = indexAtBeginning(in: .current), let end = indexAtEnd(in: .current),
            indexPath.row < beginning || indexPath.row > end {
            return true
        }
        return false
    }
    
    func weeksInMonth(month : Int, year : Int) -> Int {
        let calendar = Calendar.current
        var comps = DateComponents()
        comps.month = month+1
        comps.year = year
        comps.day = 0
        
        let last = calendar.date(from: comps)
        return calendar.component(.weekOfMonth, from: last!)
    }
    
    func display(in month: MonthType) {
        currentDates = []
        currentDate = month == .current ? Date() : date(of: month)
        setup()
    }
    
    // display month by by using string
    func  displayByMonth(in monthYearString : String) {
        currentDates = []
        currentDate = dateByMonth(of: monthYearString)
        customSetup()
    }
    
    func dateString(in month: MonthType, withFormat format: String) -> String {
        let formatter: DateFormatter = .init()
        formatter.dateFormat = format
        return formatter.string(from: date(of: month))
    }
    
    func date(at indexPath: IndexPath) -> Date {
        return currentDates[indexPath.row]
    }
    
    func willSelectDate(at indexPath: IndexPath) -> Date? {
        let date = currentDates[indexPath.row]
        return selectedDates[date] == true ? nil : date
    }
    
    func unselectAll() {
        selectedDates.keys(of: true).forEach { selectedDates[$0] = false }
    }
    
    func select(with indexPath: IndexPath) {
        let selectedDate = date(at: indexPath)
        
        switch selectionMode {
        case .single:
            selectedDates.forEach { [weak self] date, isSelected in
                guard let me = self else { return }
                if selectedDate == date {
                    me.selectedDates[date] = me.selectedDates[date] == true ? false : true
                } else if isSelected {
                    me.selectedDates[date] = false
                }
            }
        default: break
        }
    }
    
    
    func isSelect(with indexPath: IndexPath) -> Bool {
        let date = currentDates[indexPath.row]
        return selectedDates[date] ?? false
    }
    
    func isHighlighted(with indexPath: IndexPath) -> Bool {
        let date = currentDates[indexPath.row]
        return highlightedDates.contains(date)
    }
    
    
    
    func week(at index: Int) -> String {
        switch index {
        case 0:  return weeks.0
        case 1:  return weeks.1
        case 2:  return weeks.2
        case 3:  return weeks.3
        case 4:  return weeks.4
        case 5:  return weeks.5
        case 6:  return weeks.6
        default: return ""
        }
    }
}

// MARK: - Private Methods -

private extension DateModel {
    var calendar: Calendar { return Calendar.current }
    
    func setup() {
        selectedDates = [:]
        
        guard let indexAtBeginning = indexAtBeginning(in: .current) else { return }
        
        var components: DateComponents = .init()
        currentDates = (0..<DateModel.maxCellCount).flatMap { index in
            components.day = index - indexAtBeginning
            return calendar.date(byAdding: components, to: atBeginning(of: .current))
            }
            .map { (date: Date) in
                selectedDates[date] = false
                return date
        }
        
        let selectedDateKeys = selectedDates.keys(of: true)
        selectedDateKeys.forEach { selectedDates[$0] = true }
    }
    
    func customSetup() {
        selectedDates = [:]
        
        guard let indexAtBeginning = customIndexAtBeginning(in: .current) else { return }
        
        var components: DateComponents = .init()
        currentDates = (0..<DateModel.maxCellCount).flatMap { index in
            components.day = index - indexAtBeginning
            return calendar.date(byAdding: components, to: customAtBeginning(of: .current))
            }
            .map { (date: Date) in
                selectedDates[date] = false
                return date
        }
        
        let selectedDateKeys = selectedDates.keys(of: true)
        selectedDateKeys.forEach { selectedDates[$0] = true }
    }
    
    func set(_ isSelected: Bool, withFrom fromDate: Date, to toDate: Date) {
        currentDates
            .filter { fromDate <= $0 && toDate >= $0 }
            .forEach { selectedDates[$0] = isSelected }
    }
    
    func atBeginning(of month: MonthType) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date(of: month))
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    func customAtBeginning(of month: MonthType) -> Date {
        var components = calendar.dateComponents([.year, .month, .day], from: date(of: month))
        components.day = 1
        return calendar.date(from: components) ?? Date()
    }
    
    
    func date(of month: MonthType) -> Date {
        var components = DateComponents()
        components.month = {
            switch month {
            case .previous: return -1
            case .current:  return 0
            case .next:     return 1
            }
        }()
        return calendar.date(byAdding: components, to: currentDate) ?? Date()
    }
    
    func dateByMonth(of monthYearString: String) -> Date {
        let monthYearArray = monthYearString.components(separatedBy: "-")
        
        let month    = Int(monthYearArray[1])
        let year     = Int(monthYearArray[0])
        
        let dateComponents = DateComponents(year: year, month: month)
        return calendar.date(from: dateComponents) ?? Date()
    }
}

extension Dictionary where Value: Equatable {
    func keys(of element: Value) -> [Key] {
        return filter { $0.1 == element }.map { $0.0 }
    }
}
