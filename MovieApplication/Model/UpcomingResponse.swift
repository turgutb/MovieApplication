//
//  UpcomingResponse.swift
//  MovieApplication
//
//  Created by Turgut Boztepe on 18.06.2022.
//

import Foundation

struct Upcoming: Codable {
    let dates: Dates?
    let page: Int?
    let results: [MovieResult]?
    let totalPages, totalResults: Int?

    enum CodingKeys: String, CodingKey {
        case dates, page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

