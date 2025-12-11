//
//  DataManager.swift
//  LETSGO ios App
//

import UIKit
import FirebaseFirestore

struct FriendTravelLog {
    let id: String
    let authorId: String
    let authorName: String
    let authorAvatarURL: String?
    let title: String
    let location: String
    let city: String
    let summary: String
    let startDate: Date
    let endDate: Date
    let coverImageURL: String?
    let photoURLs: [String]
    let tags: [String]
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: startDate)
    }
    
    var timeAgo: String {
        let now = Date()
        let interval = now.timeIntervalSince(startDate)
        
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)
        
        if days > 30 {
            return formattedDate
        } else if days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) min\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
}

class DataManager {
    static let shared = DataManager()
    
    private let firebaseService = FirebaseService.shared
    private let db = Firestore.firestore()
    
    private init() {}
    
    var friends: [Friend] = []
    var friendLogs: [FriendLog] = []
    var friendTravelLogs: [FriendTravelLog] = []
    
    var onDataUpdated: (() -> Void)?
    
    func fetchFriends(completion: ((Bool) -> Void)? = nil) {
        guard let userId = firebaseService.currentUserId else {
            completion?(false)
            return
        }
        
        db.collection("users").document(userId).collection("friends").getDocuments { [weak self] snapshot, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error fetching friends: \(error.localizedDescription)")
                completion?(false)
                return
            }
            
            let friendIds = snapshot?.documents.map { $0.documentID } ?? []
            
            guard !friendIds.isEmpty else {
                self.friends = []
                self.friendLogs = []
                self.friendTravelLogs = []
                DispatchQueue.main.async {
                    self.onDataUpdated?()
                    completion?(true)
                }
                return
            }
            
            let group = DispatchGroup()
            var fetchedFriends: [Friend] = []
            
            for friendId in friendIds {
                group.enter()
                self.firebaseService.getUserProfile(uid: friendId) { result in
                    defer { group.leave() }
                    
                    if case .success(let user) = result {
                        let friend = Friend(
                            uid: friendId,
                            username: user.username,
                            region: "Travel Buddy",
                            email: user.email,
                            note: user.bio ?? "",
                            phoneNumber: "",
                            nickname: nil,
                            avatarURL: user.avatarURL
                        )
                        fetchedFriends.append(friend)
                    }
                }
            }
            
            group.notify(queue: .main) {
                self.friends = fetchedFriends
                self.onDataUpdated?()
                completion?(true)
                
                self.fetchFriendsTravelLogs()
            }
        }
    }
    
    func fetchFriendsTravelLogs(completion: ((Bool) -> Void)? = nil) {
        guard let userId = firebaseService.currentUserId else {
            completion?(false)
            return
        }
        
        firebaseService.fetchFriendsTravelLogs(for: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let logsWithAuthors):
                    self?.friendTravelLogs = logsWithAuthors.map { item in
                        FriendTravelLog(
                            id: item.log.id,
                            authorId: item.log.userId,
                            authorName: item.author.username,
                            authorAvatarURL: item.author.avatarURL,
                            title: item.log.title,
                            location: item.log.location,
                            city: item.log.city,
                            summary: item.log.summary,
                            startDate: item.log.startDate,
                            endDate: item.log.endDate,
                            coverImageURL: item.log.coverImageURL,
                            photoURLs: item.log.photoURLs,
                            tags: item.log.tags
                        )
                    }
                    
                    self?.friendLogs = logsWithAuthors.map { item in
                        FriendLog(
                            name: item.author.username,
                            location: item.log.city,
                            activity: item.log.title,
                            time: self?.formatTimeAgo(from: item.log.startDate) ?? ""
                        )
                    }
                    
                    self?.onDataUpdated?()
                    completion?(true)
                    
                case .failure(let error):
                    print("Error fetching friend travel logs: \(error.localizedDescription)")
                    completion?(false)
                }
            }
        }
    }
    
    private func formatTimeAgo(from date: Date) -> String {
        let now = Date()
        let interval = now.timeIntervalSince(date)
        
        let minutes = Int(interval / 60)
        let hours = Int(interval / 3600)
        let days = Int(interval / 86400)
        
        if days > 30 {
            let formatter = DateFormatter()
            formatter.dateStyle = .medium
            return formatter.string(from: date)
        } else if days > 0 {
            return "\(days) day\(days == 1 ? "" : "s") ago"
        } else if hours > 0 {
            return "\(hours) hour\(hours == 1 ? "" : "s") ago"
        } else if minutes > 0 {
            return "\(minutes) min\(minutes == 1 ? "" : "s") ago"
        } else {
            return "Just now"
        }
    }
    
    func addFriend(_ friend: Friend, completion: ((Bool) -> Void)? = nil) {
        firebaseService.searchUsers(query: friend.username) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let users):
                guard let friendUser = users.first(where: { $0.username.lowercased() == friend.username.lowercased() }),
                      let currentUserId = self.firebaseService.currentUserId else {
                    DispatchQueue.main.async {
                        completion?(false)
                    }
                    return
                }
                
                self.firebaseService.addFriend(currentUserId: currentUserId, friendId: friendUser.uid) { result in
                    DispatchQueue.main.async {
                        switch result {
                        case .success:
                            self.fetchFriends(completion: completion)
                        case .failure(let error):
                            print("Error adding friend: \(error.localizedDescription)")
                            completion?(false)
                        }
                    }
                }
                
            case .failure(let error):
                print("Error searching for user: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion?(false)
                }
            }
        }
    }
    
    func removeFriend(username: String, completion: ((Bool) -> Void)? = nil) {
        guard let friend = friends.first(where: { $0.username.lowercased() == username.lowercased() }),
              let friendUid = friend.uid,
              let currentUserId = firebaseService.currentUserId else {
            DispatchQueue.main.async {
                completion?(false)
            }
            return
        }
        
        firebaseService.removeFriend(currentUserId: currentUserId, friendId: friendUid) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    self?.friends.removeAll { $0.username.lowercased() == username.lowercased() }
                    self?.friendTravelLogs.removeAll { $0.authorName.lowercased() == username.lowercased() }
                    self?.friendLogs.removeAll { $0.name.lowercased() == username.lowercased() }
                    self?.onDataUpdated?()
                    completion?(true)
                case .failure(let error):
                    print("Error removing friend: \(error.localizedDescription)")
                    completion?(false)
                }
            }
        }
    }
    
    func updateFriendNickname(username: String, nickname: String?) {
        if let index = friends.firstIndex(where: { $0.username == username }) {
            let friend = friends[index]
            friends[index] = Friend(
                uid: friend.uid,
                username: friend.username,
                region: friend.region,
                email: friend.email,
                note: friend.note,
                phoneNumber: friend.phoneNumber,
                nickname: nickname,
                avatarURL: friend.avatarURL
            )
            onDataUpdated?()
        }
    }
    
    func clearData() {
        friends = []
        friendLogs = []
        friendTravelLogs = []
        onDataUpdated?()
    }
}

extension Result {
    var isSuccess: Bool {
        if case .success = self { return true }
        return false
    }
}
