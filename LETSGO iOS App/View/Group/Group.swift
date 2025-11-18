//
//  Group.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

struct Group: Equatable {
    enum Mode {
        case create
        case edit
    }

    let id: UUID
    var destination: String
    var startDate: Date
    var budget: Int
    var spotsLeft: Int
    var organizer: String
    var description: String
    var members: [GroupMember]

    static var sampleData: [Group] {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd"
        return [
            Group(
                id: UUID(),
                destination: "Boston Autumn Leaf Trail",
                startDate: formatter.date(from: "2025/12/05") ?? Date(),
                budget: 450,
                spotsLeft: 3,
                organizer: "Lychee_Ann",
                description: "A fall foliage hiking trip to the best leaf-peeping spots around Boston.",
                members: [
                    GroupMember(name: "Lychee_Ann", accentColor: .systemPink),
                    GroupMember(name: "Han", accentColor: .systemTeal)
                ]
            ),
            Group(
                id: UUID(),
                destination: "Shanghai Night Bites Sprint",
                startDate: formatter.date(from: "2025/12/18") ?? Date(),
                budget: 520,
                spotsLeft: 2,
                organizer: "Brunce_Lee",
                description: "A late-night food crawl across Shanghai’s top street eats and hidden alley snacks.",
                members: [
                    GroupMember(name: "Brunce_Lee", accentColor: .systemOrange),
                    GroupMember(name: "Mike", accentColor: .systemPurple),
                    GroupMember(name: "joy", accentColor: .systemGreen)
                ]
            ),
            Group(
                id: UUID(),
                destination: "Chiang Mai Lantern Run",
                startDate: formatter.date(from: "2026/01/10") ?? Date(),
                budget: 380,
                spotsLeft: 5,
                organizer: "momo",
                description: "Backpack-friendly culture trip focused on the Yi Peng lantern festival.",
                members: [
                    GroupMember(name: "momo", accentColor: .systemBlue)
                ]
            )
        ]
    }
}

struct GroupMember: Equatable {
    let name: String
    let accentColor: UIColor
}
