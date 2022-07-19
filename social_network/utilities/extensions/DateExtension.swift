//
//  DateExtension.swift
//  social_network
//
//  Created by admin on 7/18/22.
//

import Foundation

extension Date {

    func toString(stringFormat: String) -> String {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = stringFormat
        return dateFormatterPrint.string(from: self)
    }
}
