//
//  ViewController.swift
//  Semigroup
//
//  Created by nixzhu on 2017/8/10.
//  Copyright © 2017年 nixWork. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class TableNodeViewController: ASViewController<ASTableNode> {
    var feeds: [Feed] = [
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed(),
        randomFeed()
    ]
    var tableNode: ASTableNode!
    var tableView: UITableView {
        return tableNode.view
    }

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

        title = "Table"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addItem))

        tableNode.backgroundColor = .white
    }

    @objc private func addItem() {
        let feed = randomFeed()
        let indexPath = IndexPath(row: feeds.count, section: 0)
        feeds.append(feed)

        //tableView.insertRows(at: [indexPath], with: .none)
        tableNode.insertRows(at: [indexPath], with: .none)
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
            self?.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
//        tableNode.performBatchUpdates({ [weak self] in
//            self?.tableNode.insertRows(at: [indexPath], with: .none)
//        }, completion: { [weak self] _ in
//            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) { [weak self] in
//                self?.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: true)
//            }
//        })
    }

    private var isLoadingMoreFeeds: Bool = false
    private func loadMoreFeeds(completion: ((Bool) -> Void)? = nil) {
        guard !isLoadingMoreFeeds else {
            completion?(false)
            return
        }
        isLoadingMoreFeeds = true
        DispatchQueue.global(qos: .background).asyncAfter(deadline: .now() + 0.5) {
            let newFeeds = [
                randomFeed(),
                randomFeed()
            ]
            let indexPaths = (self.feeds.count..<(self.feeds.count + newFeeds.count)).map {
                IndexPath(row: $0, section: 0)
            }
            self.feeds.append(contentsOf: newFeeds)
            DispatchQueue.main.async {
                self.tableNode.insertRows(at: indexPaths, with: .automatic)
                self.isLoadingMoreFeeds = false
                completion?(true)
            }
        }
    }
}

//extension TableNodeViewController: UIScrollViewDelegate {
//
//    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
//        let distance = scrollView.contentSize.height - (targetContentOffset.pointee.y + scrollView.bounds.height)
//        if distance < 100 {
//            loadMoreFeeds()
//        }
//    }
//}

extension TableNodeViewController: ASTableDataSource, ASTableDelegate {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.row])
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let deleteAction = UITableViewRowAction(style: .default, title: "Delete") { action, index in
            self.feeds.remove(at: indexPath.row)
            self.tableNode.deleteRows(at: [indexPath], with: .automatic)
        }
        return [deleteAction]
    }

//    func shouldBatchFetch(for tableNode: ASTableNode) -> Bool {
//        return true
//    }
//
//    func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
//        context.beginBatchFetching()
//        loadMoreFeeds {
//            context.completeBatchFetching($0)
//        }
//    }
}
