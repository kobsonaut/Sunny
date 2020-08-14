//
//  WeatherViewCell.swift
//  Sunny
//
//  Created by Polidea on 12/10/2017.
//  Copyright © 2017 Polidea. All rights reserved.
//

import UIKit

final class WeatherViewCell: UITableViewCell {

    private var descriptionLabel = UILabel()
    private var valueLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeCell() {
        selectionStyle = .none
        backgroundColor = .clear

        let desc = UILabel()
        desc.textColor = UIColor.clientWhite
        desc.font = UIFont.clientBold.withSize(28.0)
        desc.textAlignment = .left
        desc.lineBreakMode = .byTruncatingTail
        desc.numberOfLines = 1
        descriptionLabel = desc

        let value = UILabel()
        value.textColor = UIColor.clientWhite
        value.font = UIFont.clientRegular.withSize(40.0)
        value.textAlignment = .right
        valueLabel = value

        setupConstraints()
    }

    private func setupConstraints() {
        [valueLabel, descriptionLabel].forEach {
            self.contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        let verticalInset: CGFloat = 8
        let horizontalInset: CGFloat = 12
        let constraints = [
            descriptionLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: horizontalInset),
            descriptionLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            descriptionLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            valueLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -horizontalInset),
            valueLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: verticalInset),
            valueLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -verticalInset),
            valueLabel.leadingAnchor.constraint(lessThanOrEqualTo: descriptionLabel.trailingAnchor, constant: 10)
        ]
        constraints.forEach { $0.isActive = true }
    }
}

extension WeatherViewCell {
    func update(with item: WeatherRowItem) {
        if item.title == UserDefaults.standard.currentLocation {
            descriptionLabel.text = item.currentLocationName
        } else {
            descriptionLabel.text = item.title
        }

        valueLabel.text = item.temperature
    }
}
