// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorDetailsModel = try? JSONDecoder().decode(ActorDetailsModel.self, from: jsonData)

import Foundation

// MARK: - ActorDetailsModel
struct ActorDetailsModel: Decodable {
    let adult: Bool
    let alsoKnownAs: [String]
    let biography, birthday: String
    let deathday: String?
    let gender: Int
    let id: Int
    let imdbID, knownForDepartment, name, placeOfBirth: String
    let popularity: Double
    let profilePath: String?

    enum CodingKeys: String, CodingKey {
        case adult
        case alsoKnownAs = "also_known_as"
        case biography, birthday, deathday, gender, id
        case imdbID = "imdb_id"
        case knownForDepartment = "known_for_department"
        case name
        case placeOfBirth = "place_of_birth"
        case popularity
        case profilePath = "profile_path"
    }
}
