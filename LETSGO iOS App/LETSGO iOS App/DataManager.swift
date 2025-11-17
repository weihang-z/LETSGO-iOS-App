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
            Friend(username: "Alice", region: "Chengdu", note: "Loves spicy food"),
            Friend(username: "Bob", region: "Xiamen", note: "Cycling buddy")
        ]
    }
}
