//
//  GroupDataStore.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class GroupDataStore {
    private(set) var groups: [Group]
    let currentUser = "you"

    init(groups: [Group] = Group.sampleData) {
        self.groups = groups
    }

    func group(with id: UUID) -> Group? {
        return groups.first(where: { $0.id == id })
    }

    func add(_ group: Group) {
        groups.insert(group, at: 0)
    }

    func update(_ group: Group) {
        guard let index = groups.firstIndex(where: { $0.id == group.id }) else { return }
        groups[index] = group
    }

    @discardableResult
    func joinGroup(id: UUID, memberName: String) -> Group? {
        guard let index = groups.firstIndex(where: { $0.id == id }) else { return nil }
        var target = groups[index]
        guard target.spotsLeft > 0, target.members.contains(where: { $0.name == memberName }) == false else {
            return target
        }
        target.spotsLeft -= 1
        let newMember = GroupMember(name: memberName, accentColor: .systemGray)
        target.members.append(newMember)
        groups[index] = target
        return target
    }
}
