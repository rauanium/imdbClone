// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let actorImagesModel = try? JSONDecoder().decode(ActorImagesModel.self, from: jsonData)

import Foundation

// MARK: - ActorImagesModel
struct ActorImagesModel: Decodable {
    let profiles: [Profile]
}

// MARK: - Profile
struct Profile: Decodable {
    let filePath: String

    enum CodingKeys: String, CodingKey {
        case filePath = "file_path"
    }
}

