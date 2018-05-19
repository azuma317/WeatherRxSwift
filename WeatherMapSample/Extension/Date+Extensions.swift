//
//  Date+Extensions.swift
//  WeatherMapSample
//
//  Created by Azuma on 2018/05/15.
//  Copyright © 2018年 Azuma. All rights reserved.
//

import Foundation

extension Date {
    
    func formattedTime(formatter: DateFormatter) -> String {
        formatter.setLocalizedDateFormatFromTemplate("HH:mm")
        return formatter.string(from: self)
    }
    
    func formattedDay(formatter: DateFormatter) -> String {
        formatter.setLocalizedDateFormatFromTemplate("d M")
        return formatter.string(from: self)
    }
    
    func dayOfWeek(formatter: DateFormatter) -> String {
        formatter.setLocalizedDateFormatFromTemplate("EEEE")
        return formatter.string(from: self)
    }
}
