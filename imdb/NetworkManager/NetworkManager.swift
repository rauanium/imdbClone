//
//  NetworkManager.swift
//  imdb
//
//  Created by rauan on 12/21/23.
//

import Foundation
import Alamofire

class NetworkManager {
    static var shared = NetworkManager()
    
    private let urlString: String = "https://api.themoviedb.org"
    private let apiKey: String = "88a63ecadd449652c81ed00b8200dcbf"
    private let session = URLSession(configuration: .default)
    
    private lazy var urlComponents: URLComponents = {
        var components = URLComponents()
        components.scheme = "https"
        components.host = "api.themoviedb.org"
        components.queryItems = [
            URLQueryItem(name: "api_key", value: apiKey)
        ]
        return components
    }()
    
    private let headers: HTTPHeaders = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzIyYzEwNjdjZWM3OWRlMDgyODg5Mjg5NGUzMWJkYyIsInN1YiI6IjY1YjIzYzE3MGYyZmJkMDEzMDY2YTBiNiIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.Mp_XUBq4oK4yBkE0QWgpQE-uhK_5ayYAdfjJPRkVyv0"
    ]
    
    func loadMovies(with movieStatus: String, completion: @escaping ([Result]) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(movieStatus)"
        guard let requestURL = components.url else { return }
        
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MovieModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData.results)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }

    func loadGenres(completion: @escaping ([Genre]) -> Void){
        var components = urlComponents
        components.path = "/3/genre/movie/list"
        guard let requestURL = components.url else { return }
        
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(GenresEntity.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData.genres)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func loadMovieDetails(id: Int, completion: @escaping (MovieDetailsEntity) -> Void){
        var components = urlComponents
        components.path = "/3/movie/\(id)"
        guard let requestURL = components.url else { return }
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MovieDetailsEntity.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadMovieCast(id: Int, completion: @escaping (MovieCastModel) -> Void) {
        
        var components = urlComponents
        components.path = "/3/movie/\(id)/credits"
        guard let requestURL = components.url else { return }
        
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(MovieCastModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadVideos(id: Int, completion: @escaping ([Video]) -> Void) {
        
        var components = urlComponents
        components.path = "/3/movie/\(id)/videos"
        guard let requestURL = components.url else { return }
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(VideoEntity.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData.results)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadExternalID(id: Int, completion: @escaping (ExternalIDModel) -> Void) {
        var components = urlComponents
        components.path = "/3/movie/\(id)/external_ids"
        guard let requestURL = components.url else { return }
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ExternalIDModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadActorDetails(id: Int, completion: @escaping(ActorDetailsModel) -> Void){
        var components = urlComponents
        components.path = "/3/person/\(id)"
        guard let requestURL = components.url else { return }
        
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ActorDetailsModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func loadActorImages(id: Int, completion: @escaping(ActorImagesModel) -> Void){
        
        var components = urlComponents
        components.path = "/3/person/\(id)/images"
        guard let requestURL = components.url else { return }
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ActorImagesModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func loadActorsMovies(id: Int, completion: @escaping (ActorsMoviesModel) -> Void) {
        
        var components = urlComponents
        components.path = "/3/person/\(id)/movie_credits"
        guard let requestURL = components.url else { return }
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ActorsMoviesModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func loadActorsSocialMedia(id: Int, completion: @escaping (ActorsSocialMediaModel)->Void){
        var components = urlComponents
        components.path = "/3/person/\(id)/external_ids"
        guard let requestURL = components.url else { return }
        
        AF.request(requestURL, headers: headers).responseData { response in
            switch response.result {
            case .success(let data):
                do {
                    let decodedData = try JSONDecoder().decode(ActorsSocialMediaModel.self, from: data)
                    DispatchQueue.main.async {
                        completion(decodedData)
                    }
                }
                catch {
                    print(error)
                }
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    func getRequestToken(completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
        let requestTokenURL = "https://api.themoviedb.org/3/authentication/token/new"
        if let url = URL(string: requestTokenURL) {
            AF.request(url, headers: headers).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
                        completion(.success(requestTokenModel))
                    }
                    catch {
                        completion(.failure(.incorrectJSON))
                    }
                case .failure:
                    completion(.failure(.unknown))
                }
            }
        } else {
            completion(.failure(.unknown))
        }
    }
    
    
    func validateWithLogin(requestBody: [String: Any], completion: @escaping (APIResult<RequestTokenModel>) -> Void) {
        let requestTokenURL = "https://api.themoviedb.org/3/authentication/token/validate_with_login"
        
        var components = urlComponents
        components.path = "/3/authentication/token/validate_with_login"
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "application/json"
        
        
        if let url = URL(string: requestTokenURL) {
            AF.request(url, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: requestHeaders).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        let requestTokenModel = try JSONDecoder().decode(RequestTokenModel.self, from: data)
                        completion(.success(requestTokenModel))
                    }
                    catch {
                        completion(.failure(.incorrectJSON))
                    }
                case .failure:
                    completion(.failure(.unknown))
                }
            }
        } else {
            completion(.failure(.unknown))
        }
    }
    
    func createSession(requestBody: [String: Any], completion: @escaping (APIResult<String>) -> Void) {
        
        var components = urlComponents
        components.path = "/3/authentication/session/new"
        
        var requestHeaders = headers
        requestHeaders["Content-Type"] = "application/json"
        
        let requestTokenURL = "https://api.themoviedb.org/3/authentication/session/new"
        if let url = URL(string: requestTokenURL) {
            AF.request(url, method: .post, parameters: requestBody, encoding: JSONEncoding.default, headers: requestHeaders).responseData { response in
                switch response.result {
                case .success(let data):
                    do {
                        if let responseData = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any], 
                           let success = responseData["success"] as? Bool,
                           success,
                           let sessionID = responseData["session_id"] as? String {
                            completion(.success(sessionID))
                        } else {
                            completion(.failure(.filedWith(reason: "Failed to create session")))
                        }
                    }
                    catch {
                        completion(.failure(.incorrectJSON))
                    }
                case .failure:
                    completion(.failure(.unknown))
                }
            }
        } else {
            completion(.failure(.unknown))
        }
    }
    
    
        
//https://api.themoviedb.org/3/person/1190668/images?api_key=821fba2e86cbb574aecf827d251585b9 - actor images
//https://api.themoviedb.org/3/person/1190668/movie_credits?api_key=821fba2e86cbb574aecf827d251585b9 - actors movies

    
    
}
