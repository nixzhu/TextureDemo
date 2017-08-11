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
    var feeds: [Feed] = []
    var tableNode: ASTableNode!

    init() {
        let tableNode = ASTableNode(style: .plain)
        super.init(node: tableNode)

        tableNode.dataSource = self
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
        tableNode.performBatchUpdates({ [weak self] in
            self?.tableNode.insertRows(at: [indexPath], with: .none)
        }, completion: { [weak self] _ in
            self?.tableNode.scrollToRow(at: indexPath, at: .bottom, animated: true)
        })
    }
}

extension TableNodeViewController: ASTableDataSource {

    func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
        return feeds.count
    }

    func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
        let cell = FeedCellNode(feed: feeds[indexPath.row])
        return cell
    }
}
