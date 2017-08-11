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

func randomFeed() -> Feed {
    let json1 = """
        {
          "creator": {
            "nickname": "NIX",
            "avatar_url": "https://cdn-images-1.medium.com/fit/c/64/64/1*4ELWYhLQbcZXs1NkMMmd2Q@2x.jpeg"
          },
          "body": "明月几时有，把酒问青天。不知天上宫阙，今夕是何年？我欲乘风归去，又恐琼楼玉宇，高处不胜寒。",
          "attachments": [
          ],
          "created_at": 1500000000
        }
        """
    let json2 = """
        {
          "creator": {
            "nickname": "轻墨",
            "avatar_url": "http://qingmo.me/images/readingbook.jpg"
          },
          "body": "生命好似被上帝精心编排的话剧，年少时学习，长大了工作，然后结婚生子，抚养小孩，照看父母，最后垂垂老去。一幕接着一幕，一幕赶着一幕。貌似自由意志，其实我们只有润色生活这么一点点权限。",
          "attachments": [
            {
              "image_url": "http://qingmo.me/images/lifeisgood.jpg"
            }
          ],
          "created_at": 1500000000
        }
        """
    let json3 = """
        {
          "creator": {
            "nickname": "NIX",
            "avatar_url": "https://cdn-images-1.medium.com/fit/c/64/64/1*4ELWYhLQbcZXs1NkMMmd2Q@2x.jpeg"
          },
          "body": "其实我并不是一个爱冒险的人，而且结构工程师、设计院，也是不少人梦寐以求的，在社会上颇受尊重，但自己身在其中，总有太多的烦躁相伴，痛苦相随。痛苦是很有价值的感受，因为无论你怎么偏离你命中注定的航线，它都会一点一点地将你校正到正确的方向，即使你不勇敢，它也会让你变得义无反顾。",
          "attachments": [
            {
              "image_url": "http://shellhue.github.io/images/1.jpeg"
            },
            {
              "image_url": "http://shellhue.github.io/images/2.jpeg"
            }
          ],
          "created_at": 1500000000
        }
        """
    let jsons = [json1, json2, json3]
    let json = jsons[Int(arc4random()) % jsons.count]
    let data = json.data(using: .utf8)!
    let decoder = JSONDecoder()
    decoder.dateDecodingStrategy = .secondsSince1970
    let feed = try! decoder.decode(Feed.self, from: data)
    return feed
}
