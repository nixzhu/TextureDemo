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

extension Array {
    subscript(safe index: Int) -> Element? {
        return indices ~= index ? self[index] : nil
    }
}

class FeedCellNode: ASCellNode {
    let avatarImageNode = ASNetworkImageNode()
    let nicknameTextNode = ASTextNode()
    let createdAtTextNode = ASTextNode()
    let bodyTextNode = ASTextNode()
    let attachmentImageNode1 = ASNetworkImageNode()
    let attachmentImageNode2 = ASNetworkImageNode()
    let attachmentImageNode3 = ASNetworkImageNode()

    let feed: Feed

    init(feed: Feed) {
        self.feed = feed
        super.init()

        backgroundColor = .white

        avatarImageNode.url = feed.creator.avatarURL
        nicknameTextNode.attributedText = NSAttributedString(string: feed.creator.nickname)
        createdAtTextNode.attributedText = NSAttributedString(string: "\(feed.createdAt)")
        bodyTextNode.attributedText = NSAttributedString(string: feed.body)
        attachmentImageNode1.url = feed.attachments[safe: 0]?.imageURL
        attachmentImageNode2.url = feed.attachments[safe: 1]?.imageURL
        attachmentImageNode3.url = feed.attachments[safe: 2]?.imageURL

        addSubnode(avatarImageNode)
        addSubnode(nicknameTextNode)
        addSubnode(createdAtTextNode)
        addSubnode(bodyTextNode)
        addSubnode(attachmentImageNode1)
        addSubnode(attachmentImageNode2)
        addSubnode(attachmentImageNode3)
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
        let stack5 = ASStackLayoutSpec(
            direction: .vertical,
            spacing: 10,
            justifyContent: .start,
            alignItems: .start,
            children: [stack3]
        )
        if !feed.attachments.isEmpty {
            let stack4 = ASStackLayoutSpec(
                direction: .horizontal,
                spacing: 10,
                justifyContent: .start,
                alignItems: .start,
                children: []
            )
            if feed.attachments[safe: 0] != nil {
                attachmentImageNode1.style.preferredSize = CGSize(width: 100, height: 100)
                stack4.children?.append(attachmentImageNode1)
            }
            if feed.attachments[safe: 1] != nil {
                attachmentImageNode2.style.preferredSize = CGSize(width: 100, height: 100)
                stack4.children?.append(attachmentImageNode2)
            }
            if feed.attachments[safe: 2] != nil {
                attachmentImageNode3.style.preferredSize = CGSize(width: 100, height: 100)
                stack4.children?.append(attachmentImageNode3)
            }
            stack5.children?.append(stack4)
        }
        let inset = ASInsetLayoutSpec(
            insets: UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10),
            child: stack5
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

    private var scrollToBottomTask: DispatchWorkItem?

    private let tableLock = DispatchSemaphore(value: 1)
    private func waitTableLockToDo(_ work: @escaping () -> Void) {
        DispatchQueue.global().async {
            _ = self.tableLock.wait(timeout: .distantFuture)
            work()
        }
    }
    private func unlockTableLock() {
        tableLock.signal()
    }

    @objc private func addItem() {
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
        let indexPath = IndexPath(row: feeds.count, section: 0)
        feeds.append(feed)
        waitTableLockToDo { [weak self] in
            DispatchQueue.main.async { [weak self] in
                self?.tableNode.performBatchUpdates({ [weak self] in
                    self?.tableNode.insertRows(at: [indexPath], with: .none)
                }, completion: { [weak self] _ in
                    self?.unlockTableLock()
                })
            }
        }
        waitTableLockToDo { [weak self] in
            self?.scrollToBottomTask?.cancel()
            let task = DispatchWorkItem { [weak self] in
                self?.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: true)
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1, execute: task)
            self?.scrollToBottomTask = task
            self?.unlockTableLock()
        }
    }
}

extension ViewController: ASTableDataSource, ASTableDelegate {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.row])
        return cell
    }

    func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
        defer {
            tableNode.deselectRow(at: indexPath, animated: true)
        }
        print("did select row at: \(indexPath)")
    }
}
