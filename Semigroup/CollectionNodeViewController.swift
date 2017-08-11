//
//  ViewController.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/10.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class CollectionNodeViewController: ASViewController<ASCollectionNode> {
    var feeds: [Feed] = []
    var collectionNode: ASCollectionNode!

    init() {
        let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)

        collectionNode.dataSource = self
        self.collectionNode = collectionNode
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = "Collection"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))

        collectionNode.backgroundColor = .white
    }

    @objc private func addItem() {
        let feed = randomFeed()
        let indexPath = IndexPath(row: feeds.count, section: 0)
        feeds.append(feed)
        collectionNode.performBatchUpdates({ [weak self] in
            self?.collectionNode.insertItems(at: [indexPath])
        }, completion: { [weak self] _ in
            self?.collectionNode.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }
}

extension CollectionNodeViewController: ASCollectionDataSource {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.row])
        return cell
    }
}
