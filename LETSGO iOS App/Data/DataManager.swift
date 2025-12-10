//
//  DataManager.swift
//  LETSGO ios App
//

import Foundation

class DataManager {
    static let shared = DataManager()
    
    private init() {
        loadSampleData()
    }
    
    // MARK: - Properties
    var friends: [Friend] = []
    var friendLogs: [FriendLog] = []
    
    // MARK: - Methods
    func addFriend(_ friend: Friend) {
        friends.append(friend)
        // Also add a log entry for the new friend
        let log = FriendLog(
            name: friend.username,
            location: friend.region,
            activity: friend.note,
            time: "Just now"
        )
        friendLogs.insert(log, at: 0) // Add to beginning
    }
    
    func loadSampleData() {
        // Sample friend logs
        friendLogs = [
            FriendLog(name: "Alice", location: "Chengdu", activity: "Hotpot was amazing!", time: "2 hours ago"),
            FriendLog(name: "Bob", location: "Xiamen", activity: "Island cycling", time: "1 day ago")
        ]
        
        // Sample friends - only 2
        friends = [
            Friend(username: "Alice", region: "Chengdu", email: "alice@example.com", note: "Loves spicy food", phoneNumber: "503-555-1111", nickname: nil),
            Friend(username: "Bob", region: "Xiamen", email: "bob@example.com", note: "Cycling buddy", phoneNumber: "415-555-2222", nickname: nil)
        ]
    }
    
    func updateFriendNickname(username: String, nickname: String?) {
        if let index = friends.firstIndex(where: { $0.username == username }) {
            let friend = friends[index]
            friends[index] = Friend(
                username: friend.username,
                region: friend.region,
                email: friend.email,
                note: friend.note,
                phoneNumber: friend.phoneNumber,
                nickname: nickname
            )
        }
    }
}
