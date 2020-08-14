//
//  WeatherViewController.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

final class WeatherDetailViewController: UIViewController {

    private enum Constants {
        static let rowHeight = CGFloat(50.0)
    }

    private let dataSource: ArrayDataSource<WeatherDetailRowItem>

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
        title = LanguageManager.shared.localizedString(forKey: "lang_weather_title")
    }

    private func configureTableView() {
        tableView.register(WeatherDetailViewCell.self, forCellReuseIdentifier: dataSource.cellReuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        let bgImage = UIImageView(image: UIImage(named: "sky-bg"))
        bgImage.frame = self.tableView.frame
        self.tableView.backgroundView = bgImage
    }
}

extension WeatherDetailViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return Constants.rowHeight
    }
}
