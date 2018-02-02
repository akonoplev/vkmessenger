//
//  DateService.swift
//  VKmessanger
//
//  Created by Андрей Коноплев on 23.01.2018.
//  Copyright © 2018 Андрей Коноплев. All rights reserved.
//

import Foundation

class DateSerice {
    class func dateTransform (date: Date) -> String
    {
        
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.timeStyle = DateFormatter.Style.short //Set time style
        dateFormatter.dateStyle = DateFormatter.Style.medium //Set date style
        dateFormatter.timeZone = TimeZone.current
        let localDate = dateFormatter.string(from: date as Date)
        return localDate
    }
}
