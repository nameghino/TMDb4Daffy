//
//  MovieDetailsViewModel.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

class MovieDetailsViewModel {
    let movie: Movie

    init(movie: Movie) {
        self.movie = movie
    }

    private static var yearFormatter: DateFormatter = {
        let df = DateFormatter()
        df.dateFormat = "y"
        return df
    }()

    var title: String { return movie.title }
    var tagline: String? { return movie.tagline }
    var yearOfRelease: String? {
        return movie.releaseDate.map { MovieDetailsViewModel.yearFormatter.string(from: $0) }
    }

    var overview: String? { return movie.overview }

    var posterPath: URL? { return movie.posterPath }
}
