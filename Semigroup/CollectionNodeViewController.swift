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
    var feeds: [Feed] = [
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed()
    ]
    var collectionNode: ASCollectionNode!

    init() {
        let collectionNode = ASCollectionNode(collectionViewLayout: UICollectionViewFlowLayout())
        super.init(node: collectionNode)

        collectionNode.dataSource = self
        collectionNode.delegate = self
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
        let indexPath = IndexPath(item: feeds.count, section: 0)
        feeds.append(feed)
        collectionNode.performBatchUpdates({ [weak self] in
            self?.collectionNode.insertItems(at: [indexPath])
        }, completion: { [weak self] _ in
            self?.collectionNode.scrollToItem(at: indexPath, at: .bottom, animated: true)
        })
    }

    private var isLoadingMoreFeeds: Bool = false
    private func loadMoreFeeds(completion: ((Bool) -> Void)? = nil) {
        guard !isLoadingMoreFeeds else {
            completion?(false)
            return
        }
        isLoadingMoreFeeds = true
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.1) {
            let newFeeds = [
                randomFeed(),
                randomFeed(),
                randomFeed(),
                randomFeed()
            ]
            let indexPaths = (self.feeds.count..<(self.feeds.count + newFeeds.count)).map {
                IndexPath(item: $0, section: 0)
            }
            self.feeds.append(contentsOf: newFeeds)
            DispatchQueue.main.async {
                self.collectionNode.insertItems(at: indexPaths)
                self.isLoadingMoreFeeds = false
                completion?(true)
            }
        }
    }
}

extension CollectionNodeViewController: ASCollectionDataSource, ASCollectionDelegate {

    func collectionNode(_ collectionNode: ASCollectionNode, numberOfItemsInSection section: Int) -> Int {
        return feeds.count
    }

    func collectionNode(_ collectionNode: ASCollectionNode, nodeForItemAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.item])
        return cell
    }

    func shouldBatchFetch(for collectionNode: ASCollectionNode) -> Bool {
        return true
    }

    func collectionNode(_ collectionNode: ASCollectionNode, willBeginBatchFetchWith context: ASBatchContext) {
        context.beginBatchFetching()
        loadMoreFeeds {
            context.completeBatchFetching($0)
        }
    }
}
