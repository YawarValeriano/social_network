//
//  FriendRequestStatus.swift
//  social_network
//
//  Created by admin on 7/29/22.
//

import Foundation

enum FriendRequestStatus: String, Codable, CaseIterable {
case Pending,
    NewRequest = "Send Request",
    Accepted,
    Rejected
}
