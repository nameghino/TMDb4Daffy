//
//  PersonDetailsViewBuilder.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

class PersonDetailsViewBuilder: DetailsViewBuilder {

    var viewModel: PersonDetailsViewModel

    init(viewModel: PersonDetailsViewModel) {
        self.viewModel = viewModel
    }

    private lazy var container: UIView = {
        return UIView()
    }()

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.alignment = .leading
        stackView.spacing = 8

        stackView.addArrangedSubview(self.nameLabel)

        if let dobLabel {
            stackView.addArrangedSubview(dobLabel)
        }

        if let profileImageView {
            stackView.addArrangedSubview(profileImageView)
        }

        if let creditsStackView {
            stackView.addArrangedSubview(creditsStackView)
        }


        return stackView
    }()

    private lazy var nameLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.name
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var dobLabel: UIView? = {
        guard let dob = viewModel.dateOfBirthString else { return nil }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = dob
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var profileImageView: UIImageView? = {
        guard let posterPath = viewModel.profilePath else { return nil }
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.alpha = 0

        Task {
            do {
                let image: UIImage = try await self.getImage(for: posterPath, type: .poster)
                let aspectRatio = image.size.width / image.size.height

                await NSLayoutConstraint.activate([
                    imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor, multiplier: aspectRatio)
                ])

                DispatchQueue.main.async {
                    imageView.image = image
                    UIView.animate(withDuration: 0.3) {
                        imageView.alpha = 1
                    }
                }
            }
        }

        return imageView
    }()

    private lazy var creditsStackView: UIStackView? = {
        let stackView = UIStackView()
        stackView.spacing = 3
        stackView.axis = .vertical
        stackView.distribution = .fillEqually

        Task {
            self.viewModel.onCreditsUpdated = {
                DispatchQueue.main.async {
                    stackView.arrangedSubviews.forEach { stackView.removeArrangedSubview($0) }
                    stackView.addArrangedSubview(self.creditsHeaderLabel)
                    for (iconName, credit) in self.viewModel.knownFor {
                        let row = self.buildCreditsRow(iconName: iconName, credit: credit)
                        stackView.addArrangedSubview(row)
                    }
                }
            }

            self.viewModel.loadCredits()
        }

        return stackView
    }()

    private lazy var creditsHeaderLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Known for"
        label.font = UIFont.preferredFont(forTextStyle: .title3)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    func buildCreditsRow(iconName: String, credit: String) -> UIView {
        let row = UIStackView()
        row.axis = .horizontal
        row.spacing = 5

        let iconView = UIImageView(image: UIImage(systemName: iconName))
        iconView.translatesAutoresizingMaskIntoConstraints = false
        iconView.widthAnchor.constraint(equalTo: iconView.heightAnchor).isActive = true
        row.addArrangedSubview(iconView)
        
        let label = UILabel()
        label.numberOfLines = 0
        label.text = credit
        label.font = UIFont.preferredFont(forTextStyle: .body)
        row.addArrangedSubview(label)

        return row
    }

    func buildCard() -> UIView {
        self.stackView
    }
}
