//
//  GroupDataStore.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit
import FirebaseFirestore
import FirebaseAuth

final class GroupDataStore {
    private(set) var groups: [Group]
    private let firebaseService = FirebaseService.shared
    private let db = Firestore.firestore()
    
    var currentUser: String {
        return firebaseService.currentUser?.displayName ?? firebaseService.currentUser?.email ?? "you"
    }
    
    var onGroupsUpdated: (() -> Void)?

    init(groups: [Group] = Group.sampleData) {
        self.groups = groups
        if firebaseService.isLoggedIn {
            fetchGroupsFromFirebase()
        }
    }
    
    
    func fetchGroupsFromFirebase(completion: ((Bool) -> Void)? = nil) {
        db.collection("groups").order(by: "startDate", descending: false).getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching groups: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            let fetchedGroups = snapshot?.documents.compactMap { doc -> Group? in
                return Group(document: doc)
            } ?? []
            
            DispatchQueue.main.async {
                if !fetchedGroups.isEmpty {
                    self.groups = fetchedGroups
                }
                self.onGroupsUpdated?()
                completion?(true)
            }
        }
    }

    func group(with id: UUID) -> Group? {
        return groups.first(where: { $0.id == id })
    }

    func add(_ group: Group) {
        groups.insert(group, at: 0)
        
        saveGroupToFirebase(group)
    }
    
    private func saveGroupToFirebase(_ group: Group) {
        let data = group.toDictionary()
        db.collection("groups").document(group.id.uuidString).setData(data) { error in
            if let error = error {
                print("Error saving group: \(error.localizedDescription)")
            }
        }
    }

    func update(_ group: Group) {
        guard let index = groups.firstIndex(where: { $0.id == group.id }) else { return }
        groups[index] = group
        
        saveGroupToFirebase(group)
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
        
        saveGroupToFirebase(target)
        
        return target
    }

    @discardableResult
    func leaveGroup(id: UUID, memberName: String) -> Group? {
        guard let index = groups.firstIndex(where: { $0.id == id }) else { return nil }
        var target = groups[index]
        guard target.organizer != memberName else { return target }
        guard let removalIndex = target.members.firstIndex(where: { $0.name == memberName }) else {
            return target
        }
        target.members.remove(at: removalIndex)
        target.spotsLeft += 1
        groups[index] = target
        
        saveGroupToFirebase(target)
        
        return target
    }

    @discardableResult
    func deleteGroup(id: UUID) -> Group? {
        guard let index = groups.firstIndex(where: { $0.id == id }) else { return nil }
        let removed = groups.remove(at: index)
        
        db.collection("groups").document(id.uuidString).delete { error in
            if let error = error {
                print("Error deleting group: \(error.localizedDescription)")
            }
        }
        
        return removed
    }
    
    func clearData() {
        groups = Group.sampleData
        onGroupsUpdated?()
    }
}

extension Group {
    init?(document: DocumentSnapshot) {
        guard let data = document.data(),
              let idString = data["id"] as? String,
              let id = UUID(uuidString: idString),
              let destination = data["destination"] as? String,
              let city = data["city"] as? String,
              let theme = data["theme"] as? String,
              let startDate = (data["startDate"] as? Timestamp)?.dateValue(),
              let budget = data["budget"] as? Int,
              let spotsLeft = data["spotsLeft"] as? Int,
              let organizer = data["organizer"] as? String,
              let description = data["description"] as? String else {
            return nil
        }
        
        let organizerData = data["organizerProfile"] as? [String: Any]
        let organizerProfile = OrganizerProfile(
            username: organizerData?["username"] as? String ?? organizer,
            tagline: organizerData?["tagline"] as? String ?? "",
            homeCity: organizerData?["homeCity"] as? String ?? city,
            avatarSystemName: organizerData?["avatarSystemName"] as? String ?? "person.circle.fill"
        )
        
        let membersData = data["members"] as? [[String: Any]] ?? []
        let members = membersData.map { memberData -> GroupMember in
            GroupMember(
                name: memberData["name"] as? String ?? "",
                accentColor: .systemGray
            )
        }
        
        self.init(
            id: id,
            destination: destination,
            city: city,
            theme: theme,
            startDate: startDate,
            budget: budget,
            spotsLeft: spotsLeft,
            organizer: organizer,
            organizerProfile: organizerProfile,
            description: description,
            members: members
        )
    }
    
    func toDictionary() -> [String: Any] {
        return [
            "id": id.uuidString,
            "destination": destination,
            "city": city,
            "theme": theme,
            "startDate": Timestamp(date: startDate),
            "budget": budget,
            "spotsLeft": spotsLeft,
            "organizer": organizer,
            "description": description,
            "organizerProfile": [
                "username": organizerProfile.username,
                "tagline": organizerProfile.tagline,
                "homeCity": organizerProfile.homeCity,
                "avatarSystemName": organizerProfile.avatarSystemName
            ],
            "members": members.map { ["name": $0.name] }
        ]
    }
}
