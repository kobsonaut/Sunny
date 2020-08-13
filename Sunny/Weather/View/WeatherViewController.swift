//
//  WeatherViewController.swift
//  Sunny
//
//  Created by Kobsonauta on 11/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import UIKit

final class WeatherViewController: UIViewController {

    private let appContext = AppContext()
    private let dataSource: UpdatableArrayDataSource<WeatherRowItem, WeatherServiceError>
    private let alertService = AlertService()
    private var weatherService = WeatherService()

    init(dataSource: UpdatableArrayDataSource<WeatherRowItem, WeatherServiceError>, weatherService: WeatherService) {
        self.dataSource = dataSource
        self.weatherService = weatherService
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private var tableView: UITableView {
        guard let tableView = view as? UITableView else { fatalError("Wrong view subclass") }
        return tableView
    }

    private var refreshControl: UIRefreshControl!

    override func loadView() {
        let tableView = UITableView(frame: .zero)
        let control = UIRefreshControl()
        self.refreshControl = control
        control.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        tableView.addSubview(control)
        view = tableView
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        addNavbarItems()
        title = NSLocalizedString("Sunny", comment: "")
        dataSource.reload()
    }

    @objc private func handleRefresh() {
        dataSource.reload()
    }

    private func configureTableView() {
        tableView.register(WeatherViewCell.self, forCellReuseIdentifier: dataSource.cellReuseIdentifier)
        tableView.dataSource = dataSource
        tableView.delegate = self
        tableView.separatorStyle = .none
        dataSource.registerReloadFinishedCallback({ [weak self] error in
            if self?.refreshControl.isRefreshing == true {
                self?.refreshControl.endRefreshing()
            }
            if let error = error {
                print("Error while getting the data: \(error)")
            } else {
                self?.tableView.reloadData()
            }
        })
    }

    func addNavbarItems() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add,
                                                            target: self,
                                                            action: #selector(didTapAddButton))
    }

    @objc private func didTapAddButton() {
        let alert = alertService.createLocationAlert { (cityName) in
            self.weatherService.addCityWeather(for: cityName)
        }
        present(alert, animated: true)
    }
}

extension WeatherViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let weatherDetailVC = appContext.weatherDetailVC
        let item = dataSource.elements[indexPath.row]
        weatherDetailVC.items = item.rowWeatherDetailItems
        self.navigationController?.pushViewController(weatherDetailVC,
                                                      animated: true)
    }
}
