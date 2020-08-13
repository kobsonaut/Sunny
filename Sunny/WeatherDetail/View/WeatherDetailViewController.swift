//
//  WeatherViewController.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {

    private let dataSource: ArrayDataSource<WeatherDetailRowItem>
    var items = [WeatherDetailRowItem]()

    init(dataSource: ArrayDataSource<WeatherDetailRowItem>) {
        self.dataSource = dataSource
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var tableView: UITableView {
        guard let tableView = view as? UITableView else { fatalError("Wrong view subclass") }
        return tableView
    }

    override func loadView() {
        let tableView = UITableView(frame: .zero)
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        title = NSLocalizedString("Sunny", comment: "")
    }

    private func configureTableView() {
        tableView.register(WeatherViewCell.self, forCellReuseIdentifier: dataSource.cellReuseIdentifier)
        dataSource.elements = items
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
    }
}

extension WeatherDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}
