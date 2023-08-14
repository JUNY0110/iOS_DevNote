//
//  Model.swift
//  MusicApp
//
//  Created by 지준용 on 2023/08/11.
//


import Foundation

// MARK: - Music
struct MusicData: Codable {
    let resultCount: Int
    let results: [Music]
}

// MARK: - Result
struct Music: Codable {
    let songTitle: String?
    let artistName: String?
    let albumName: String?
    let previewURL: String?
    let imageURL: String?
    let releaseDate: String?
    
    enum CodingKeys: String, CodingKey {
        case songTitle = "trackName"
        case artistName
        case albumName = "collectionName"
        case previewURL
        case imageURL = "artworkUrl100"
        case releaseDate
    }
    
    var releaseDateString: String? {
        guard let isoDate = ISO8601DateFormatter().date(from: releaseDate ?? "") else { return "" }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = .current
        let localeID = Locale.preferredLanguages.first ?? "ko_KR"
        dateFormatter.locale = Locale(identifier: localeID)
        let date = dateFormatter.string(from: isoDate)
        return date
    }
}
