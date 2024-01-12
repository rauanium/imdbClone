// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let externalID = try? JSONDecoder().decode(ExternalID.self, from: jsonData)

import Foundation

// MARK: - ExternalID
struct ExternalIDModel: Codable {
    let id: Int
    let imdbID, wikidataID, facebookID, instagramID: String
    let twitterID: String

    enum CodingKeys: String, CodingKey {
        case id
        case imdbID = "imdb_id"
        case wikidataID = "wikidata_id"
        case facebookID = "facebook_id"
        case instagramID = "instagram_id"
        case twitterID = "twitter_id"
    }
}
