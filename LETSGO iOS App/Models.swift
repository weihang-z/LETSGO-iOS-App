//
//  Models.swift
//  LETSGO ios App
//

import Foundation

struct FriendLog {
    let name: String
    let location: String
    let activity: String
    let time: String
}

struct Friend {
    let username: String
    let region: String
    let note: String
    let phoneNumber: String
    var nickname: String?
}
