//
//  GroupCardCell.swift
//  LETSGO iOS App
//
//  Created by zft on 17/11/2025.
//

import UIKit

final class GroupCardCell: UITableViewCell {
    static let reuseIdentifier = "GroupCardCell"

    private let containerView = UIView()
    private let destinationLabel = UILabel()
    private let dateLabel = UILabel()
    private let spotsLabel = UILabel()
    private let budgetLabel = UILabel()
    private let themeLabel = UILabel()
    private let organizerLabel = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureUI()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureUI()
    }

    func configure(with group: Group, formatter: DateFormatter) {
        destinationLabel.text = group.destination
        dateLabel.text = formatter.string(from: group.startDate)
        spotsLabel.text = "Spots left: \(group.spotsLeft)"
        budgetLabel.text = "Budget: $\(group.budget)"
        themeLabel.text = "\(group.theme) · \(group.city)"
        organizerLabel.text = "Organizer: @\(group.organizer)"
        dateLabel.text = "📅 " + formatter.string(from: group.startDate)
        spotsLabel.text = "🚗 Spots left: \(group.spotsLeft)"
        budgetLabel.text = "💰 Budget: $\(group.budget)"
        themeLabel.text = "🎯 \(group.theme) · \(group.city)"
        organizerLabel.text = "👤 Organizer: @\(group.organizer)"
    }

    private func configureUI() {
        selectionStyle = .none
        backgroundColor = .clear

        containerView.backgroundColor = UIColor.secondarySystemBackground
        containerView.layer.cornerRadius = 16
        containerView.layer.cornerCurve = .continuous
        containerView.layer.shadowColor = UIColor.black.withAlphaComponent(0.05).cgColor
        containerView.layer.shadowOpacity = 1
        containerView.layer.shadowRadius = 8
        containerView.layer.shadowOffset = CGSize(width: 0, height: 4)

        let labels = [destinationLabel, dateLabel, spotsLabel, budgetLabel, themeLabel, organizerLabel]
        labels.forEach {
            $0.translatesAutoresizingMaskIntoConstraints = false
            $0.numberOfLines = 1
        }
        destinationLabel.font = UIFont.preferredFont(forTextStyle: .headline)
        dateLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        spotsLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        budgetLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        themeLabel.font = UIFont.preferredFont(forTextStyle: .subheadline)
        organizerLabel.font = UIFont.preferredFont(forTextStyle: .footnote)
        organizerLabel.textColor = .secondaryLabel

        let stack = UIStackView(arrangedSubviews: labels)
        stack.axis = .vertical
        stack.spacing = 6
        stack.translatesAutoresizingMaskIntoConstraints = false

        contentView.addSubview(containerView)
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(stack)

        NSLayoutConstraint.activate([
            containerView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10),
            containerView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10),
            containerView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            containerView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            stack.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16),
            stack.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -16),
            stack.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16),
            stack.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -16)
        ])
    }
}
