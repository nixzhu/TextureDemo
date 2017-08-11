//
//  ViewController.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/10.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit
import AsyncDisplayKit

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

class FeedCellNode: ASCellNode {
    let avatarImageNode = ASNetworkImageNode()
    let nicknameTextNode = ASTextNode()
    let createdAtTextNode = ASTextNode()
    let bodyTextNode = ASTextNode()

    init(feed: Feed) {
        super.init()
        backgroundColor = .white

        avatarImageNode.url = feed.creator.avatarURL
        nicknameTextNode.attributedText = NSAttributedString(string: feed.creator.nickname)
        createdAtTextNode.attributedText = NSAttributedString(string: "\(feed.createdAt)")
        bodyTextNode.attributedText = NSAttributedString(string: feed.body)

        addSubnode(avatarImageNode)
        addSubnode(nicknameTextNode)
        addSubnode(createdAtTextNode)
        addSubnode(bodyTextNode)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        let stack1 = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [nicknameTextNode, createdAtTextNode]
        )
        avatarImageNode.style.preferredSize = CGSize(width: 40, height: 40)
        let stack2 = ASStackLayoutSpec(
            direction: .horizontal,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [avatarImageNode, stack1]
        )
        let stack3 = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [stack2, bodyTextNode]
        )
        let inset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
            child: stack3
        )
        return inset
    }
}

class ViewController: ASViewController<ASTableNode> {

    var feeds: [Feed] = []
    var tableNode: ASTableNode!

    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)

        tableNode.dataSource = self
        tableNode.delegate = self
        self.tableNode = tableNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Semigroup"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))
        tableNode.backgroundColor = .white
        tableNode.view.tableFooterView = UIView()
    }

    @objc private func addItem() {
        let json = """
            {
              "creator": {
                "nickname": "NIX",
                "avatar_url": "https://cdn-images-1.medium.com/fit/c/64/64/1*4ELWYhLQbcZXs1NkMMmd2Q@2x.jpeg"
              },
              "body": "some string",
              "attachments": [
                {
                  "image_url": "https://cdn-images-1.medium.com/max/1600/1*LUPZaYjLsiziaMnRJwN4SA.png"
                }
              ],
              "created_at": 1500000000
            }
            """
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        decoder.dateDecodingStrategy = .secondsSince1970
        let feed = try! decoder.decode(Feed.self, from: data)
        let indexPath = IndexPath(row: feeds.count, section: 0)
        feeds.append(feed)
        tableNode.insertRows(at: [indexPath], with: .automatic)
    }
}

extension ViewController: ASTableDataSource, ASTableDelegate {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.row])
        //cell.style.preferredSize.height = 100
        return cell
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableNode.deselectRow(at: indexPath, animated: true)
        }
        print("did select row at: \(indexPath)")
    }
}
