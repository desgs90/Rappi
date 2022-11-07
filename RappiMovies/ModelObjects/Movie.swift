//
//  Movie.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import Foundation

struct MoviesResponse: Decodable {
    let results: [Movie]
}

struct Movie: Decodable,Hashable {
    let id: Int?
    let title: String?
    let original_title: String?
    let original_language: String?
    let overview: String?
    let popularity: Float?
    let backdrop_path: String?
    let poster_path: String?
    let vote_average: Float?
    let release_date: String? //yyyy-mm-dd
}
struct VideoResponse: Decodable {
    let results: [Video]
}
struct Video: Decodable {
    let id: String?
    let key: String?
    let site: String?
    let official: Bool?
}
