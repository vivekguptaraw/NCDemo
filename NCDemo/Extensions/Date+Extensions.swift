//
//  Date+Extensions.swift
//  NCDemo
//
//  Created by Vivek Gupta on 29/06/18.
//  Copyright © 2018 Vivek Gupta. All rights reserved.
//

import Foundation

extension Date{
    init?(fromString string: String, format: String) {
        let formatter = DateFormatter()
        formatter.dateFormat = format // "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
        guard let date = formatter.date(from: string) else {
            return nil
        }
        self.init(timeInterval:0, since:date)
    }
    
    func toString(format: String) -> String{
        let formatter = DateFormatter()
        formatter.dateFormat = "d"
        return formatter.string(from: self)
    }
}
