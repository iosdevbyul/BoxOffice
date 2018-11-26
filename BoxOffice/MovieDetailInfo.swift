//
//  MovieDetailInfo.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-09-13.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import Foundation

//struct MovieInfoApi: Codable {
//    let movieInfoArray : MovieInfo
//}

struct MovieInfo: Codable {
    let audience: Int
    let actor: String
    let duration: Int
    let director: String
    let synopsis: String
    let genre: String
    let grade: Int
    let image: String
    let reservation_grade: Int
    let title: String
    let reservation_rate: Double
    let user_rating: Double
    let date: String
    let id: String
}
