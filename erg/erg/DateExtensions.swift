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
        df.dateFormat = "d MMMM"
        return df
    }()
    
    private static let databaseDateFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "yyyy-MM-dd HH:mm:ss Z"
        return df
    }()

    public func asFullDate() -> String? {
        return Date.fullDateFormatter.string(from: self)
    }
    
    public func asDatabaseString() -> String? {
        return Date.databaseDateFormatter.string(from: self)
    }
}

extension String {
    public func databaseStringToDate() -> Date? {
        let isoDate = "yyyy-MM-dd HH:mm:ss Z"
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = isoDate
        guard let date = dateFormatter.date(from: self) else {
//            fatalError("ERROR: Date conversion failed due to mismatched format.")
            return nil
        }
        
        return date
    }
}

