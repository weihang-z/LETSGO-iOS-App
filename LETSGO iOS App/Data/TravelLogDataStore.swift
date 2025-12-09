//
//  TravelLogDataStore.swift
//  LETSGO iOS App
//
//  Created by zft on 09/12/2025.
//

import Foundation

struct TravelLogEntry {
    let id: UUID
    let title: String
    let location: String
    let city: String
    let startDate: Date
    let endDate: Date
    let summary: String
    let isPrivate: Bool
    let tags: [String]
    let photoCount: Int
    
    var year: Int {
        Calendar.current.component(.year, from: startDate)
    }
}

final class TravelLogDataStore {
    static let shared = TravelLogDataStore()
    
    private(set) var logs: [TravelLogEntry]
    
    private init() {
        logs = TravelLogDataStore.sampleLogs
    }
    
    func add(_ entry: TravelLogEntry) {
        logs.insert(entry, at: 0)
    }
}

private extension TravelLogDataStore {
    static var sampleLogs: [TravelLogEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            TravelLogEntry(
                id: UUID(),
                title: "Trip to Eiffel Tower",
                location: "Paris, France",
                city: "Paris",
                startDate: formatter.date(from: "2024/11/10") ?? Date(),
                endDate: formatter.date(from: "2024/11/15") ?? Date(),
                summary: "An amazing trip to the iconic Eiffel Tower in Paris. The view from the top was breathtaking and the city lights at night were magical. We enjoyed delicious French cuisine and explored the charming streets of the city.",
                isPrivate: true,
                tags: ["travel", "paris", "adventure"],
                photoCount: 5
            ),
            TravelLogEntry(
                id: UUID(),
                title: "Kyoto Autumn Sketchbook",
                location: "Kyoto, Japan",
                city: "Kyoto",
                startDate: formatter.date(from: "2023/10/18") ?? Date(),
                endDate: formatter.date(from: "2023/10/23") ?? Date(),
                summary: "Morning matcha runs, biking through Arashiyama bamboo, and painting temple rooftops in warm yellow tones.",
                isPrivate: false,
                tags: ["art", "asia", "fall"],
                photoCount: 8
            ),
            TravelLogEntry(
                id: UUID(),
                title: "Desert Stargazing Retreat",
                location: "Shanghai, China",
                city: "Shanghai",
                startDate: formatter.date(from: "2022/05/05") ?? Date(),
                endDate: formatter.date(from: "2022/05/09") ?? Date(),
                summary: "Dawn hikes across quiet dunes, stargazing workshops, and late-night journaling beneath a glowing Milky Way.",
                isPrivate: true,
                tags: ["desert", "citywalk", "night"],
                photoCount: 4
            )
        ]
    }
}
