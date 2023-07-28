//
//  DateFormatter+Extension.swift
//  TodoList
//
//  Created by 지준용 on 2023/07/19.
//

import Foundation

extension String {
    func convertToDate() -> Date {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = (self.contains("🕓 ") ? "🕓 " : "") + "yyyy.MM.dd (EEEEEE)"
        dateFormatter.timeZone = .current
        let localeID = Locale.preferredLanguages.first ?? "ko_KR"
        dateFormatter.locale = Locale(identifier: localeID)
        guard let date = dateFormatter.date(from: self) else { return Date() }
        return date
    }
}

extension Date {
    func convertToString() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd (EEEEEE)"
        dateFormatter.timeZone = .current
        let localeID = Locale.preferredLanguages.first ?? "ko_KR"
        dateFormatter.locale = Locale(identifier: localeID)
        let date = dateFormatter.string(from: self)
        return date
    }
}
