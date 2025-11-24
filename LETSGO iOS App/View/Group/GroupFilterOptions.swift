//
//  GroupFilterOptions.swift
//  LETSGO iOS App
//
//  Created by zft on 22/11/2025.
//
import Foundation

struct GroupFilterOptions {
    var maxBudget: Int?
    var fromDate: Date?
    var cityKeyword: String?
    var themeKeyword: String?

    var isEmpty: Bool {
        let cityEmpty = cityKeyword?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        let themeEmpty = themeKeyword?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true
        return maxBudget == nil &&
        fromDate == nil &&
        cityEmpty &&
        themeEmpty
    }

    mutating func clear() {
        maxBudget = nil
        fromDate = nil
        cityKeyword = nil
        themeKeyword = nil
    }

    func matches(_ group: Group) -> Bool {
        if let maxBudget {
            guard group.budget <= maxBudget else { return false }
        }

        if let fromDate {
            let calendar = Calendar.current
            let normalized = calendar.startOfDay(for: fromDate)
            if group.startDate < normalized {
                return false
            }
        }

        if let cityKeyword, cityKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            let key = cityKeyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            let matchesCity = group.city.lowercased().contains(key)
            let matchesDestination = group.destination.lowercased().contains(key)
            if matchesCity == false && matchesDestination == false {
                return false
            }
        }

        if let themeKeyword, themeKeyword.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty == false {
            let key = themeKeyword.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
            if group.theme.lowercased().contains(key) == false {
                return false
            }
        }

        return true
    }
}
