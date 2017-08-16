//
//  FeedCellNode.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/11.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit
import AsyncDisplayKit

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

        automaticallyManagesSubnodes = true
//        addSubnode(avatarImageNode)
//        addSubnode(nicknameTextNode)
//        addSubnode(createdAtTextNode)
//        addSubnode(bodyTextNode)
//        addSubnode(attachmentImageNode1)
//        addSubnode(attachmentImageNode2)
//        addSubnode(attachmentImageNode3)
    }

    override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
        nicknameTextNode.style.flexShrink = 1
        createdAtTextNode.style.flexShrink = 1
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
        bodyTextNode.style.flexShrink = 1
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
