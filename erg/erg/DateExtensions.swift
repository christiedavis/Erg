//
//  DateExtensions.swift
//  erg
//
//  Created by Christie on 22/03/18.
//  Copyright © 2018 star. All rights reserved.
//

import UIKit

extension Date {
    private static let formattingCalendar = Calendar(identifier: .gregorian)
    private static let formattingTimezone = TimeZone(identifier: "Pacific/Auckland")
    
    private static let fullDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "d MMMM YYYY"
        return df
    }()

    public func asFullDate() -> String? {
        return Date.fullDateFormatter.string(from: self)
    }
}

