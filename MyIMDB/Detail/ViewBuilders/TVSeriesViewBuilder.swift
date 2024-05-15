//
//  TVSeriesViewBuilder.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

class TVSeriesDetailsViewBuilder: DetailsViewBuilder {

    var viewModel: TVSeriesDetailsViewModel

    init(viewModel: TVSeriesDetailsViewModel) {
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

        stackView.addArrangedSubview(self.titleLabel)

        if let subtitleStackView {
            stackView.addArrangedSubview(subtitleStackView)
        }

        if let posterImageView {
            stackView.addArrangedSubview(posterImageView)
        }

        if let overviewLabel {
            stackView.addArrangedSubview(overviewLabel)
        }

        return stackView
    }()

    private lazy var titleLabel: UIView = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = viewModel.name
        label.font = UIFont.preferredFont(forTextStyle: .largeTitle)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var subtitleStackView: UIView? = {
        let releaseDateLabel = self.releaseDateLabel
        let seasonsAndEpisodes = self.seasonsAndEpisodesLabel

        if releaseDateLabel == nil && seasonsAndEpisodes == nil { return nil }

        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .fill

        for label in [releaseDateLabel, seasonsAndEpisodes] {
            if let label {
                stackView.addArrangedSubview(label)
            }
        }

        return stackView
    }()

    private lazy var releaseDateLabel: UIView? = {
        guard let yor = viewModel.yearOfRelease else { return nil }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = yor
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var seasonsAndEpisodesLabel: UIView? = {
        guard let yor = viewModel.seasonsAndEpisodes else { return nil }

        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = yor
        label.font = UIFont.preferredFont(forTextStyle: .caption1)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultHigh, for: .vertical)
        return label
    }()

    private lazy var overviewLabel: UIView? = {
        guard let overview = viewModel.overview else { return nil }
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = overview
        label.numberOfLines = 0
        label.font = UIFont.preferredFont(forTextStyle: .body)
        label.textColor = .black
        label.backgroundColor = .clear
        label.sizeToFit()
        label.setContentHuggingPriority(.defaultLow, for: .vertical)
        return label
    }()

    private lazy var posterImageView: UIImageView? = {
        guard let posterPath = viewModel.posterPath else { return nil }
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

    func buildCard() -> UIView {
        return self.stackView
    }

    var images: [ImageKey : Data] = [:]
}
