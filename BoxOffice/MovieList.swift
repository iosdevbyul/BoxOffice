//
//  MovieList.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-08-15.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import Foundation

struct APIResponse: Codable {
    let movies: [Movie]
}

struct Movie: Codable {
    let grade: Int
    let thumb: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
}
