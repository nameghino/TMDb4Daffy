//
//  SearchViewController.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import UIKit

enum SearchCollectionViewSection: Int, CaseIterable {
    case movies = 0, tvSeries, people

    var title: String {
        switch self {
        case .movies:
            return "Movies"
        case .tvSeries:
            return "TV Series"
        case .people:
            return "People"
        }
    }
}

class SearchViewController: UIViewController {
    private let viewModel: SearchViewModel

    init(viewModel: SearchViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.searchController = self.setupSearchController()
    }

    required init?(coder: NSCoder) {
        fatalError("Unimplemented")
    }

    private lazy var collectionView: UICollectionView = {

        var configuration = UICollectionLayoutListConfiguration(appearance: .plain)
//        configuration.headerMode = .supplementary

        let layout = UICollectionViewCompositionalLayout.list(using: configuration)


        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.dataSource = self.collectionViewDataSource
        collectionView.delegate = self
        return collectionView
    }()

    private lazy var collectionViewDataSource: UICollectionViewDataSource = {
        return SearchResultsDataSourceWrapper(viewModel: self.viewModel)
    }()

    private var searchController: UISearchController!

    @discardableResult
    private func setupSearchController() -> UISearchController {
        let controller = UISearchController(searchResultsController: nil)
        controller.isActive = true
        controller.searchResultsUpdater = self
        controller.obscuresBackgroundDuringPresentation = false
        controller.searchBar.placeholder = "Back to the Future"
        controller.searchBar.showsScopeBar = true
        controller.searchBar.scopeButtonTitles = self.viewModel.scopes.map { $0.title }
        controller.searchBar.delegate = self

        self.navigationItem.searchController = controller

        return controller
    }

    override func viewDidLoad() {
        self.title = "TMDB Search"
        self.view.backgroundColor = .red

        self.viewModel.onResultsUpdate = { [unowned self] in
            DispatchQueue.main.async { [unowned self] in self.collectionView.reloadData() }
        }

        self.view.addSubview(self.collectionView)

        NSLayoutConstraint.activate([
            self.collectionView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            self.collectionView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            self.collectionView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            self.collectionView.heightAnchor.constraint(equalTo: self.view.heightAnchor),
        ])
    }

    private var shouldAutofill: Bool = true
    private func autofillForTesting() {
        // Testing code!
        self.searchController.searchBar.text = "back to the future"
        self.searchController.searchBar.selectedScopeButtonIndex = 1

        self.updateSearchResults(for: self.searchController)
        self.searchBar(self.searchController.searchBar, selectedScopeButtonIndexDidChange: 1)
        self.searchBarSearchButtonClicked(self.searchController.searchBar)
    }

    override func viewDidAppear(_ animated: Bool) {
        if self.shouldAutofill {
            self.autofillForTesting()
            self.shouldAutofill = false
        }
    }
}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.viewModel.search()
    }

    func searchBar(_ searchBar: UISearchBar, selectedScopeButtonIndexDidChange selectedScope: Int) {
        self.viewModel.selectedScopeIndex = selectedScope
        if !self.viewModel.query.isEmpty {
            self.viewModel.search()
        }
    }
}

extension SearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
        self.viewModel.query = text
    }
}

extension SearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.selectItem(at: indexPath)
    }
}
