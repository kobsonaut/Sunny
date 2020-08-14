//
//  ArrayDataSource.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

class ArrayDataSource<Item>: NSObject, UITableViewDataSource {

    typealias TableViewCellConfigureBlock = (_ cell: UITableViewCell, _ item: Item) -> Void
    private var configureBlock: TableViewCellConfigureBlock
    let cellReuseIdentifier: String
    var elements = [Item]()

    init(cellIdentifier: String,
         elements: [Item],
         configureCellBlock: @escaping TableViewCellConfigureBlock) {
        self.elements = elements
        cellReuseIdentifier = cellIdentifier
        configureBlock = configureCellBlock
        super.init()
    }

    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return elements.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier, for: indexPath)
        let item = elements[indexPath.row]
        configureBlock(cell, item)
        return cell
    }

    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return false
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
    }
}
