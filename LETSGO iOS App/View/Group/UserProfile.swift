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

struct SocialUser {
    let id: UUID
    let username: String
    let tagline: String
    let city: String
    let avatarSystemName: String

    var avatarImage: UIImage? {
        UIImage(systemName: avatarSystemName)
    }
}

struct CityVisit {
    let id: UUID
    let cityName: String
    let country: String
    let latitude: Double
    let longitude: Double
    let note: String
}

final class UserContentDataStore {
    private(set) var profile: UserProfile
    private(set) var userGroups: [UserGroupSummary]
    private(set) var userJournals: [JournalEntry]
    private(set) var joinedGroups: [Group]
    private(set) var followers: [SocialUser]
    private(set) var following: [SocialUser]
    private(set) var visitedCities: [CityVisit]

    init(profile: UserProfile? = nil,
         groups: [UserGroupSummary]? = nil,
         joinedGroups: [Group]? = nil,
         journals: [JournalEntry]? = nil,
         followers: [SocialUser]? = nil,
         following: [SocialUser]? = nil,
         visitedCities: [CityVisit]? = nil) {
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
        self.userJournals = journals ?? []
        self.joinedGroups = joinedGroups ?? UserContentDataStore.defaultJoinedGroups
        self.followers = followers ?? UserContentDataStore.defaultFollowers
        self.following = following ?? UserContentDataStore.defaultFollowing
        self.visitedCities = visitedCities ?? UserContentDataStore.defaultVisitedCities
    }

    func updateProfile(_ profile: UserProfile) {
        self.profile = profile
    }

    func removeJoinedGroup(with id: UUID) {
        joinedGroups.removeAll { $0.id == id }
    }

    func addJoinedGroup(_ group: Group) {
        if let index = joinedGroups.firstIndex(where: { $0.id == group.id }) {
            joinedGroups[index] = group
        } else {
            joinedGroups.append(group)
        }
    }

    func addVisitedCity(_ city: CityVisit) {
        visitedCities.append(city)
    }

    func removeVisitedCity(with id: UUID) {
        visitedCities.removeAll { $0.id == id }
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

    static var defaultJournals: [JournalEntry] { [] }

    static var defaultJoinedGroups: [Group] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            Group(
                id: UUID(),
                destination: "Seoul Neon Nights",
                city: "Seoul",
                theme: "City Explorer",
                startDate: formatter.date(from: "2026/02/14") ?? Date(),
                budget: 610,
                spotsLeft: 2,
                organizer: "luna",
                organizerProfile: OrganizerProfile(
                    username: "luna",
                    tagline: "Late-night foodie tours",
                    homeCity: "Seoul",
                    avatarSystemName: "sparkles"
                ),
                description: "Dive into Hongdae’s live music bars, late-night cafes, and neon alleys.",
                members: [
                    GroupMember(name: "luna", accentColor: .systemPurple),
                    GroupMember(name: "Han", accentColor: .systemBlue)
                ]
            ),
            Group(
                id: UUID(),
                destination: "Lisbon Rooftop Sketchers",
                city: "Lisbon",
                theme: "Art & Culture",
                startDate: formatter.date(from: "2026/03/08") ?? Date(),
                budget: 540,
                spotsLeft: 4,
                organizer: "sketch.with.ana",
                organizerProfile: OrganizerProfile(
                    username: "sketch.with.ana",
                    tagline: "Sunset watercolor sessions",
                    homeCity: "Lisbon",
                    avatarSystemName: "paintbrush.pointed.fill"
                ),
                description: "Slow mornings at Alfama viewpoints with sketchbooks and pastel de nata runs.",
                members: [
                    GroupMember(name: "sketch.with.ana", accentColor: .systemOrange),
                    GroupMember(name: "Marta", accentColor: .systemPink),
                    GroupMember(name: "Han", accentColor: .systemTeal)
                ]
            ),
            Group(
                id: UUID(),
                destination: "Patagonia Glacier Wake-Up Call",
                city: "El Calafate",
                theme: "Adventure",
                startDate: formatter.date(from: "2026/04/19") ?? Date(),
                budget: 980,
                spotsLeft: 1,
                organizer: "santi",
                organizerProfile: OrganizerProfile(
                    username: "santi",
                    tagline: "Backpacking instructor",
                    homeCity: "Buenos Aires",
                    avatarSystemName: "snowflake"
                ),
                description: "Basecamp hikes, glacier sunrise views, and journaling nights in hostels.",
                members: [
                    GroupMember(name: "santi", accentColor: .systemIndigo),
                    GroupMember(name: "Jo", accentColor: .systemGreen),
                    GroupMember(name: "Han", accentColor: .systemRed)
                ]
            )
        ]
    }

    static var defaultFollowers: [SocialUser] {
        return [
            SocialUser(id: UUID(), username: "Jojo", tagline: "Sunrise runner", city: "Taipei", avatarSystemName: "sunrise.fill"),
            SocialUser(id: UUID(), username: "Mei", tagline: "Tea & trains", city: "Chengdu", avatarSystemName: "tram.circle.fill"),
            SocialUser(id: UUID(), username: "Leo", tagline: "Budget flights hunter", city: "Singapore", avatarSystemName: "airplane.circle.fill")
        ]
    }

    static var defaultFollowing: [SocialUser] {
        return [
            SocialUser(id: UUID(), username: "Momo", tagline: "Lantern lover", city: "Chiang Mai", avatarSystemName: "sparkles"),
            SocialUser(id: UUID(), username: "Ivy", tagline: "Oceanside stays", city: "Busan", avatarSystemName: "water.waves"),
            SocialUser(id: UUID(), username: "Ken", tagline: "Climb club", city: "Denver", avatarSystemName: "mountain.2.fill")
        ]
    }

    static var defaultVisitedCities: [CityVisit] {
        return [
            CityVisit(id: UUID(), cityName: "Shanghai", country: "China", latitude: 31.2304, longitude: 121.4737, note: "Bund night walk"),
            CityVisit(id: UUID(), cityName: "Taipei", country: "Taiwan", latitude: 25.0330, longitude: 121.5654, note: "Hot pot & vinyl"),
            CityVisit(id: UUID(), cityName: "Bangkok", country: "Thailand", latitude: 13.7563, longitude: 100.5018, note: "Canal photo ride"),
            CityVisit(id: UUID(), cityName: "Boston", country: "USA", latitude: 42.3601, longitude: -71.0589, note: "Fall leaves study break")
        ]
    }
}