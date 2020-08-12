//
//  UpdatableArrayDataSource.swift
//  Sunny
//
//  Created by Polidea on 13/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import Foundation

protocol ArrayDataProvider {
    associatedtype DataType
    associatedtype ErrorType: Error
    typealias Observer = (Result<[DataType], ErrorType>) -> Void
    func registerDataObserver(_ observer: @escaping Observer)
    func refreshData()
}

class UpdatableArrayDataSource<Item, ReloadError: Error>: ArrayDataSource<Item> {
    typealias ReloadFinishedObserver = (ReloadError?) -> Void
    private var reloadCompletion: ReloadFinishedObserver?

    private var reloadClosure: () -> ()

    init<D: ArrayDataProvider>(cellIdentifier: String,
         elements: [Item],
         dataProvider: D,
         configureCellBlock: @escaping TableViewCellConfigureBlock) where D.DataType == Item, D.ErrorType == ReloadError {
        reloadClosure = {
            dataProvider.refreshData()
        }
        super.init(cellIdentifier: cellIdentifier,
                   elements: elements,
                   editable: true,
                   configureCellBlock: configureCellBlock)
        dataProvider.registerDataObserver { [weak self] result in
            switch result {
            case let .success(elements):
                self?.elements = elements
                self?.reloadCompletion?(nil)
            case let .error(error):
                self?.reloadCompletion?(error)
            }
        }
    }

    /// Register observer function that is called whenever data changes
    func registerReloadFinishedCallback(_ reloadCompletion: @escaping ReloadFinishedObserver) {
        self.reloadCompletion = reloadCompletion
    }

    /// Reloads underlying data
    func reload() {
        reloadClosure()
    }
}
