//
//  Models.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/11.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import Foundation

struct User: Codable {
    let nickname: String
    let avatarURL: URL
    private enum CodingKeys: String, CodingKey {
        case nickname
        case avatarURL = "avatar_url"
    }
}

struct Feed: Codable {
    let creator: User
    let body: String
    struct Attachment: Codable {
        let imageURL: URL
        private enum CodingKeys: String, CodingKey {
            case imageURL = "image_url"
        }
    }
    let attachments: [Attachment]
    let createdAt: Date
    private enum CodingKeys: String, CodingKey {
        case creator
        case body
        case attachments
        case createdAt = "created_at"
    }
}

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}
