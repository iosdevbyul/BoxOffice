//
//  CommentList.swift
//  BoxOffice
//
//  Created by COMATOKI on 2018-09-13.
//  Copyright © 2018 COMATOKI. All rights reserved.
//

import Foundation

struct ResponseForComments: Codable {
    let comments: [Comments]
}

struct Comments: Codable {
    let rating: Double
    let timestamp: Double
    let writer: String
    let movie_id: String
    let contents: String
}
