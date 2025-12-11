//
//  Models.swift
//  LETSGO ios App
//

import UIKit

struct FriendLog {
    let name: String
    let location: String
    let activity: String
    let time: String
}

struct Friend {
    let uid: String?
    let username: String
    let region: String
    let email: String
    let note: String
    let phoneNumber: String
    var nickname: String?
    let avatarURL: String?
    
    init(uid: String? = nil,
         username: String,
         region: String,
         email: String,
         note: String,
         phoneNumber: String,
         nickname: String? = nil,
         avatarURL: String? = nil) {
        self.uid = uid
        self.username = username
        self.region = region
        self.email = email
        self.note = note
        self.phoneNumber = phoneNumber
        self.nickname = nickname
        self.avatarURL = avatarURL
    }
}
