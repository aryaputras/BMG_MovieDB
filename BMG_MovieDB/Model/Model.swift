//
//  Model.swift
//  BMG_MovieDB
//
//  Created by Abigail Aryaputra Sudarman on 04/08/21.
//

import Foundation

struct Movies: Codable {
    var page: Int
    var results: [Movie]
}
struct Movie:Codable {
    var id: Int
    var title: String
    var overview: String
    var poster_path: String
    var vote_average: Float
    var backdrop_path: String
}


struct MovieTrailers: Codable {
    var id: Int
    var results: [MovieTrailer]
}


struct MovieTrailer:Codable {
 
    var key: String
}





struct MovieDetail: Codable{
    var title: String
    var overview: String
    var poster_path: String
    var backdrop_path: String
    var tagline: String
    var vote_average: Double
    var revenue: Int
    var homepage: String
    
    //newly added
    var runtime: Int
    var genres: [Genre]
    var release_date: String
}


struct Genre: Codable {
    var id: Int
    var name: String
  
}


//MARK:-Response example
//
//
//
//{
//  "poster_path": "/IfB9hy4JH1eH6HEfIgIGORXi5h.jpg",
//  "adult": false,
//  "overview": "Jack Reacher must uncover the truth behind a major government conspiracy in order to clear his name. On the run as a fugitive from the law, Reacher uncovers a potential secret from his past that could change his life forever.",
//  "release_date": "2016-10-19",
//  "genre_ids": [
//    53,
//    28,
//    80,
//    18,
//    9648
//  ],
//  "id": 343611,
//  "original_title": "Jack Reacher: Never Go Back",
//  "original_language": "en",
//  "title": "Jack Reacher: Never Go Back",
//  "backdrop_path": "/4ynQYtSEuU5hyipcGkfD6ncwtwz.jpg",
//  "popularity": 26.818468,
//  "vote_count": 201,
//  "video": false,
//  "vote_average": 4.19
//}
