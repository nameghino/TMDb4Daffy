//
//  AppCoordinator.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit
import TMDb

class AppCoordinator {
    lazy var navigationController: UINavigationController = {
        let navigationController = UINavigationController(rootViewController: self.rootViewController)
        return navigationController
    }()

    private lazy var rootViewController: UIViewController = {
        let viewModel = SearchViewModel()
        viewModel.eventProcessor = self
        return SearchViewController(viewModel: viewModel)
    }()

    init() {
        self.rootViewController = rootViewController
    }
}

extension AppCoordinator: SearchViewModelEventProcessor {

    func searchViewModel(_ viewModel: SearchViewModel, didSelectMedia media: Media) {
        switch media {
        case .movie(let movie):
            self.showDetails(movie: movie)
        case .tvSeries(let series):
            self.showDetails(series: series)
        case .person(let person):
            self.showDetails(person: person)
        }
    }

    func showDetails(movie: Movie) {
        let viewModel = MovieDetailsViewModel(movie: movie)
        let viewBuilder = MovieDetailsViewBuilder(viewModel: viewModel)
        let viewController = DetailsViewController(viewBuilder: viewBuilder)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func showDetails(series: TVSeries) {
        let viewModel = TVSeriesDetailsViewModel(series: series)
        let viewBuilder = TVSeriesDetailsViewBuilder(viewModel: viewModel)
        let viewController = DetailsViewController(viewBuilder: viewBuilder)
        self.navigationController.pushViewController(viewController, animated: true)
    }

    func showDetails(person: Person) {
        let viewModel = PersonDetailsViewModel(person: person)
        let viewBuilder = PersonDetailsViewBuilder(viewModel: viewModel)
        let viewController = DetailsViewController(viewBuilder: viewBuilder)
        self.navigationController.pushViewController(viewController, animated: true)
    }
}
