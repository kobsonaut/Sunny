//
//  WeatherViewCell.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

final class WeatherViewCell: UITableViewCell {

    private let valueLabel = UILabel()
    private let descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupConstraints()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setupConstraints() {
        [valueLabel, descriptionLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let verticalInset: CGFloat = 8
        let horizontalInset: CGFloat = 12
        let constraints = [
            valueLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalInset),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            descriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            descriptionLabel.leadingAnchor.constraint(lessThanOrEqualTo: valueLabel.trailingAnchor, constant: 10)
        ]
        constraints.forEach { $0.isActive = true }
    }
}

extension WeatherViewCell {
    func update(with item: WeatherRowItem) {
        valueLabel.text = item.title
        descriptionLabel.text = item.value
    }

    static var identifier: String {
        return String(describing: WeatherViewCell.self)
    }
}
