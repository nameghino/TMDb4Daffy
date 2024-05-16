//
//  PersonDetailsViewModel.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

class PersonDetailsViewModel {
    let person: Person

    init(person: Person) {
        self.person = person
    }

    var onCreditsUpdated: (() -> Void)?

    var name: String { self.person.name }

    private static var dobFormatter: DateFormatter = {
        let df = DateFormatter()
        df.locale = Locale.autoupdatingCurrent
        df.dateStyle = .short
        df.timeStyle = .none
        return df
    }()

    private static var yearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y"
        return df
    }()

    var dateOfBirthString: String? {
        return self.person.birthday.map { PersonDetailsViewModel.dobFormatter.string(from: $0) }
    }

    var profilePath: URL? { return person.profilePath }

    func loadCredits() {
        Task {
            let client = TMDBClient()
            let results = try await client.credits(for: self.person)
            var shows: [(symbolName: String, show: String)] = []

            for result in results.allShows.prefix(10) {
                switch result {
                case .movie(let movie):
                    var s = movie.title
                    if let releaseDate = movie.releaseDate {
                        s += " (\(PersonDetailsViewModel.yearFormatter.string(from: releaseDate)))"
                    }
                    shows.append(("movieclapper", s))
                case .tvSeries(let series):
                    var s = series.name

                    var periodString = ""
                    if let fad = series.firstAirDate {
                        periodString += "\(PersonDetailsViewModel.yearFormatter.string(from: fad)) - "
                    }

                    if let lad = series.lastAirDate {
                        periodString += "\(PersonDetailsViewModel.yearFormatter.string(from: lad))"
                    }

                    if !periodString.isEmpty {
                        s += " (\(periodString))"
                    }

                    shows.append(("tv", s))
                }
            }

            self.knownFor = shows
            DispatchQueue.main.async { self.onCreditsUpdated?() }
        }
    }

    var knownFor: [(symbolName: String, show: String)] = []


}
