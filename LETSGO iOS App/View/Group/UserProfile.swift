//
//  UserProfile.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

struct UserProfile {
    var username: String
    var bio: String?
    var avatarImage: UIImage?
    var citiesVisited: Int
    var travelDays: Int
    var journalsCount: Int
}

struct UserGroupSummary {
    let id: UUID
    let destination: String
    let departureDate: Date
    let budget: Int
    let peopleCount: Int
}

struct JournalEntry {
    let id: UUID
    let title: String
    let coverImage: UIImage?
    let date: Date
}

final class UserContentDataStore {
    private(set) var profile: UserProfile
    private(set) var userGroups: [UserGroupSummary]
    private(set) var userJournals: [JournalEntry]

    init(profile: UserProfile? = nil, groups: [UserGroupSummary]? = nil, journals: [JournalEntry]? = nil) {
        let fallbackProfile = UserProfile(
            username: "Han",
            bio: "Night trains, film photos, and good coffee.",
            avatarImage: UIImage(systemName: "person.crop.circle.fill"),
            citiesVisited: 12,
            travelDays: 56,
            journalsCount: 18
        )

        self.profile = profile ?? fallbackProfile
        self.userGroups = groups ?? UserContentDataStore.defaultGroups
        self.userJournals = journals ?? UserContentDataStore.defaultJournals
    }

    func updateProfile(_ profile: UserProfile) {
        self.profile = profile
    }
}

private extension UserContentDataStore {
    static var defaultGroups: [UserGroupSummary] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            UserGroupSummary(
                id: UUID(),
                destination: "Shanghai Art Weekend",
                departureDate: formatter.date(from: "2025/12/02") ?? Date(),
                budget: 680,
                peopleCount: 5
            ),
            UserGroupSummary(
                id: UUID(),
                destination: "Taipei Street Food Run",
                departureDate: formatter.date(from: "2026/01/22") ?? Date(),
                budget: 420,
                peopleCount: 4
            )
        ]
    }

    static var defaultJournals: [JournalEntry] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            JournalEntry(
                id: UUID(),
                title: "Bali Soft Tides",
                coverImage: UIImage(systemName: "photo.on.rectangle"),
                date: formatter.date(from: "2025/11/08") ?? Date()
            ),
            JournalEntry(
                id: UUID(),
                title: "Shanghai Riverside Evening",
                coverImage: UIImage(systemName: "photo.on.rectangle.angled"),
                date: formatter.date(from: "2025/10/19") ?? Date()
            )
        ]
    }
}
