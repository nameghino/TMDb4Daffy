//
//  SearchResultsDataSourceWrapper.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb
import UIKit

class SearchResultsDataSourceWrapper: NSObject, UICollectionViewDataSource {
    private let viewModel: SearchViewModel

    private lazy var movieCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Movie> = {
        UICollectionView.CellRegistration<UICollectionViewListCell, Movie> { cell, indexPath, movie in
            var content = cell.defaultContentConfiguration()
            content.text = movie.title

            if let releaseDate = movie.releaseDate {
                content.secondaryText = "\(releaseDate)"
            }

            content.image = UIImage(systemName: "movieclapper")

            if let posterURL = movie.posterPath {
                Task {
                    do {
                        let client = TMDBClient()
                        let bytes = try await client.getImage(for: posterURL, type: .poster)
                        let image = UIImage(data: bytes)
                        DispatchQueue.main.async { content.image = image }
                    } catch {
                        print("error fetching poster for \(movie.title): \(error)")
                    }
                }
            }

            cell.contentConfiguration = content
        }
    }()

    private lazy var tvSeriesCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, TVSeries> = {
        UICollectionView.CellRegistration<UICollectionViewListCell, TVSeries> { cell, indexPath, series in
            var content = cell.defaultContentConfiguration()
            content.text = series.name

            if
                let seasons = series.numberOfSeasons,
                let episodes = series.numberOfEpisodes {
                content.secondaryText = "\(episodes) episodes in \(seasons) seasons" // fixme!
            }
            content.image = UIImage(systemName: "tv")

            if let posterURL = series.posterPath {
                Task {
                    let client = TMDBClient()
                    let bytes = try await client.getImage(for: posterURL, type: .poster)
                    let image = UIImage(data: bytes)
                    DispatchQueue.main.async { content.image = image }
                }
            }

            cell.contentConfiguration = content
        }
    }()

    private lazy var personCellRegistration: UICollectionView.CellRegistration<UICollectionViewListCell, Person> = {
        UICollectionView.CellRegistration<UICollectionViewListCell, Person> { cell, indexPath, person in
            var content = cell.defaultContentConfiguration()
            content.text = person.name

            if let birthday = person.birthday {
                content.secondaryText = "\(birthday)"
            }
            content.image = UIImage(systemName: "person")
            cell.contentConfiguration = content
        }
    }()

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel

        super.init()

        // Trigger cell registration
        _ = self.movieCellRegistration
        _ = self.tvSeriesCellRegistration
        _ = self.personCellRegistration
    }

    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return SearchCollectionViewSection.allCases.count
        return 1
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection sectionIndex: Int) -> Int {

        return self.viewModel.media.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        let item = self.viewModel.media[indexPath.item]
        switch item {
        case .movie(let movie):
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.movieCellRegistration, for: indexPath, item: movie)
            return cell
        case .tvSeries(let series):
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.tvSeriesCellRegistration, for: indexPath, item: series)
            return cell
        case .person(let person):
            let cell = collectionView.dequeueConfiguredReusableCell(using: self.personCellRegistration, for: indexPath, item: person)
            return cell
        }
    }
}
