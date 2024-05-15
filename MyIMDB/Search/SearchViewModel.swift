//
//  SearchViewModel.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

protocol SearchViewModelEventProcessor: AnyObject {
    func searchViewModel(_ : SearchViewModel, didSelectMedia: Media)
}

class SearchViewModel {
    private var client: TMDBClient = TMDBClient()

    var scopes: [TMDBClient.SearchScope] = TMDBClient.SearchScope.allCases
    var selectedScopeIndex: Int = 0
    var selectedScope: TMDBClient.SearchScope { self.scopes[self.selectedScopeIndex] }

    var query: String = ""
    var media: [Media] = []

    var onResultsUpdate: (() -> Void)? = nil

    weak var eventProcessor: SearchViewModelEventProcessor?

    func search() {
        Task {
            switch selectedScope {
            case .all:
                let results = try await self.client.searchAll(query: self.query)
                self.media = results.results
            case .movies:
                let results = try await self.client.searchMovies(query: self.query)
                self.media = results.results.map { Media.movie($0) }
            case .tvSeries:
                let results = try await self.client.searchTVSeries(query: self.query)
                self.media = results.results.map { Media.tvSeries($0) }
            case .people:
                let results = try await self.client.searchPeople(query: self.query)
                self.media = results.results.map { Media.person($0) }
            }

            self.onResultsUpdate?()
        }
    }

    func selectItem(at indexPath: IndexPath) {
        let item = self.media[indexPath.item]
        self.eventProcessor?.searchViewModel(self, didSelectMedia: item)
    }

    private func updateResults(movies: [Movie] = [], tvSeries: [TVSeries] = [], people: [Person] = [], media: [Media] = []) {
        self.media = media
    }
}
