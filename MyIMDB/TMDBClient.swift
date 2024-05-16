//
//  TMDBClient.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

class TMDBClient {

    enum SearchScope: CaseIterable {
        case all, movies, tvSeries, people

        var title: String {
            switch self {
            case .all: return "All"
            case .movies: return "Movies"
            case .people: return "People"
            case .tvSeries: return "TV Series"
            }
        }
    }

    enum ImageType: String {
        case backdrop, logo, poster, profile, still
    }

    // Move these to a config stage
    //    private let apiKey: String = "64d6f9d58986479ed820fc6a6bdd547b"
    private let apiKey: String = {
        guard 
            let key = Bundle.main.object(forInfoDictionaryKey: "TMDB_API_KEY") as? String,
            !key.isEmpty,
            key != "- INSERT API KEY HERE -"
        else {
            fatalError("Set the API key in Info.plist")
        }

        return key
    }()


    private lazy var configuration: TMDbConfiguration = {
        let configuration = TMDbConfiguration(apiKey: self.apiKey)
        return configuration
    }()

    private lazy var searchService: SearchService = {
        let service = SearchService(configuration: self.configuration)
        return service
    }()

    private lazy var personService: PersonService = {
        let service = PersonService(configuration: self.configuration)
        return service
    }()

    private var imagesConfiguration: ImagesConfiguration?

    func getImagesConfiguration() async throws -> ImagesConfiguration {
        let configurationService = ConfigurationService(configuration: self.configuration)
        let apiConfiguration =  try await configurationService.apiConfiguration()
        let imagesConfiguration = apiConfiguration.images
        return imagesConfiguration
    }

    func getImage(for path: URL, type: ImageType, idealWidth: Int = Int.max) async throws -> Data {
        guard let imagesConfiguration = imagesConfiguration else {
            self.imagesConfiguration = try await getImagesConfiguration()
            return try await getImage(for: path, type: type)
        }

        let url: URL? = {
            switch type {
            case .backdrop:
                return imagesConfiguration.backdropURL(for: path, idealWidth: idealWidth)
            case .logo:
                return imagesConfiguration.logoURL(for: path, idealWidth: idealWidth)
            case .poster:
                return imagesConfiguration.posterURL(for: path, idealWidth: idealWidth)
            case .profile:
                return imagesConfiguration.profileURL(for: path, idealWidth: idealWidth)
            case .still:
                return imagesConfiguration.stillURL(for: path, idealWidth: idealWidth)
            }
        }()

        guard let url = url else {
            throw TMDbError.notFound
        }

        print(url.absoluteString)

        let request = URLRequest(url: url)
        let (data, _) = try await URLSession.shared.data(for: request)

        // we should validate the response here

        return data
    }

    func searchAll(query: String) async throws -> MediaPageableList {
        let result = try await self.searchService.searchAll(query: query)
        print("have \(result.totalPages ?? 1) pages")
        return result
    }

    func searchMovies(query: String) async throws -> MoviePageableList {
        let result = try await self.searchService.searchMovies(query: query)
        print("have \(result.totalPages ?? 1) pages")
        return result
    }

    func searchTVSeries(query: String) async throws -> TVSeriesPageableList {
        let result = try await self.searchService.searchTVSeries(query: query)
        print("have \(result.totalPages ?? 1) pages")
        return result
    }

    func searchPeople(query: String) async throws -> PersonPageableList {
        let result = try await self.searchService.searchPeople(query: query)
        print("have \(result.totalPages ?? 1) pages")
        return result
    }

    func credits(for person: Person) async throws -> PersonCombinedCredits {
        let result = try await self.personService.combinedCredits(forPerson: person.id)
        return result
    }
}
