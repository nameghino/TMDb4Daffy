//
//  DetailsViewBuilder.swift
//  MyIMDB
//
//  Created by Nicolas Ameghino on 15/05/2024.
//

import Foundation
import TMDb

struct ImageKey: Hashable {
    var url: URL
    var type: String

    init(url: URL, type: TMDBClient.ImageType) {
        self.url = url
        self.type = type.rawValue
    }

    static func key(_ url: URL, _ type: TMDBClient.ImageType) -> ImageKey {
        return ImageKey(url: url, type: type)
    }
}

// This image fetcher tried to use caching, didn't have time to fix it, so caching was removed. -n
//import UIKit
//protocol TMDBImageFetching {
//    var images: [ImageKey: Data] { get set }
//}
//
//extension TMDBImageFetching {
//    mutating func getImage(for url: URL, type: TMDBClient.ImageType) async throws -> Data {
//        let client = TMDBClient()
//
//        let key: ImageKey = .key(url, type)
//        if let cached = self.images[key] { return cached }
//        let data = try await client.getImage(for: url, type: type)
//        self.images[key] = data
//        return data
//    }
//
//    mutating func getImage(for url: URL, type: TMDBClient.ImageType) async throws -> UIImage {
//        let data: Data = try await self.getImage(for: url, type: type)
//        guard let image = UIImage(data: data) else {
//            throw TMDbError.notFound
//        }
//        return image
//    }
//}

import UIKit
protocol TMDBImageFetching {
}

extension TMDBImageFetching {
    func getImage(for url: URL, type: TMDBClient.ImageType) async throws -> Data {
        let client = TMDBClient()
        let data = try await client.getImage(for: url, type: type)
        return data
    }

    func getImage(for url: URL, type: TMDBClient.ImageType) async throws -> UIImage {
        let data: Data = try await self.getImage(for: url, type: type)
        guard let image = UIImage(data: data) else {
            throw TMDbError.notFound
        }
        return image
    }
}


protocol DetailsViewBuilder: TMDBImageFetching {
    func buildCard() -> UIView
}
