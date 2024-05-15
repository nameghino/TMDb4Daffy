//
//  TVSeriesDetailsViewModel.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

enum PluralsHelper {
    static func pluralize(amount: Int, singular: String, plural: String) -> String {
        return "\(amount) \(amount == 1 ? singular : plural)"
    }
}

class TVSeriesDetailsViewModel {
    let series: TVSeries

    init(series: TVSeries) {
        self.series = series
    }

    private static var yearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y"
        return df
    }()

    var name: String { return series.name }

    var seasonsAndEpisodes: String? {
        var components: [String] = []
        if let numberOfSeasons = series.numberOfSeasons {
            components.append(PluralsHelper.pluralize(amount: numberOfSeasons, singular: "season", plural: "seasons"))
        }

        if let numberOfEpisodes = series.numberOfEpisodes {
            components.append(PluralsHelper.pluralize(amount: numberOfEpisodes, singular: "episode", plural: "episodes"))
        }

        guard !components.isEmpty else { return nil }

        return components.joined(separator: " - ")
    }

    var yearOfRelease: String? {
        return series.firstAirDate.map { TVSeriesDetailsViewModel.yearFormatter.string(from: $0) }
    }

    var overview: String? { return series.overview }

    var posterPath: URL? { return series.posterPath }

}
