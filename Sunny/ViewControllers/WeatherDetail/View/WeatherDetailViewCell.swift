//
//  WeatherDetailViewCell.swift
//  Sunny
//
//  Created by Kobsonauta on 14/08/2020.
//  Copyright © 2020 Kacper Harasim. All rights reserved.
//

import UIKit

final class WeatherDetailViewCell: UITableViewCell {

    private var valueLabel = UILabel()
    private var descriptionLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initializeCell()
    }

    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func initializeCell() {
        backgroundColor = UIColor.clear
        selectionStyle = .none

        let desc = UILabel()
        desc.textColor = UIColor.clientWhite
        desc.font = UIFont.clientRegular.withSize(20.0)
        desc.textAlignment = .right
        descriptionLabel = desc

        let value = UILabel()
        value.textColor = UIColor.clientWhite
        value.font = UIFont.clientBold.withSize(20.0)
        value.textAlignment = .left
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

extension WeatherDetailViewCell {
    func update(with item: WeatherDetailRowItem) {
        valueLabel.text = item.title
        descriptionLabel.text = item.value
    }
}
