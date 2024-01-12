//
//  NetworkManager.swift
//  imdb
//
//  Created by rauan on 12/21/23.
//

import Foundation

class NetworkManager {
    static var shared = NetworkManager()
    
    func loadMovies(with movieStatus: String, completion: @escaping ([Result]) -> Void){
        let movieURL = "https://api.themoviedb.org/3/movie/\(movieStatus)?api_key=821fba2e86cbb574aecf827d251585b9"
        
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(MovieModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData.results)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }
    }
    
    func loadGenres(completion: @escaping ([Genre]) -> Void){
        let movieGenreURL = "https://api.themoviedb.org/3/genre/movie/list?api_key=821fba2e86cbb574aecf827d251585b9"
        
        if let url = URL(string: movieGenreURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(GenresEntity.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData.genres)
                        }
                        
                    } catch {
                        print(error)
                    }
                }
            }
            task.resume()
        }        
    }
    
    
    func loadMovieDetails(id: Int, completion: @escaping (MovieDetailsEntity) -> Void){
        let movieURL = "https://api.themoviedb.org/3/movie/\(id)?api_key=821fba2e86cbb574aecf827d251585b9"
        
        print("movie id: \(id)")
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(MovieDetailsEntity.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func loadMovieCast(id: Int, completion: @escaping (MovieCastModel) -> Void) {
        let movieURL = "https://api.themoviedb.org/3/movie/\(id)/credits?api_key=821fba2e86cbb574aecf827d251585b9"
        if let url = URL(string: movieURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(MovieCastModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
        
    }
    
    func loadVideos(id: Int, completion: @escaping ([Video]) -> Void) {
        let videoURL = "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=821fba2e86cbb574aecf827d251585b9"
        
        if let url = URL(string: videoURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(VideoEntity.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData.results)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    func loadExternalID(id: Int, completion: @escaping (ExternalIDModel) -> Void) {
        let videoURL = "https://api.themoviedb.org/3/movie/\(id)/external_ids?api_key=821fba2e86cbb574aecf827d251585b9"
        
        if let url = URL(string: videoURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(ExternalIDModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    func loadActorDetails(id: Int, completion: @escaping(ActorDetailsModel) -> Void){
        let actorURL = "https://api.themoviedb.org/3/person/\(id)?api_key=821fba2e86cbb574aecf827d251585b9"
        if let url = URL(string: actorURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
//                        print(String(data: safeData, encoding: .utf8)!)
                        let decodedData = try decoder.decode(ActorDetailsModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
        
    }
    
    
    func loadActorImages(id: Int, completion: @escaping(ActorImagesModel) -> Void){
        let actorImagesURL = "https://api.themoviedb.org/3/person/\(id)/images?api_key=821fba2e86cbb574aecf827d251585b9"
        if let url = URL(string: actorImagesURL){
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(ActorImagesModel.self, from: safeData)
                        DispatchQueue.main.async {
                            
                            completion(decodedData)
                        }
                    } catch {
                        print("error: \(error)")
                    }
                    
                }
            }
            task.resume()
        }
           
    }
    
    func loadActorsMovies(id: Int, completion: @escaping (ActorsMoviesModel) -> Void) {
        let actrosMoviesURL = "https://api.themoviedb.org/3/person/\(id)/movie_credits?api_key=821fba2e86cbb574aecf827d251585b9"
        if let url = URL(string: actrosMoviesURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
//                    print(String(data: safeData, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    do {
                        
                        let decodedData = try decoder.decode(ActorsMoviesModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
        
    }
    func loadActorsSocialMedia(id: Int, completion: @escaping (ActorsSocialMediaModel)->Void){
        let actrosMoviesURL = "https://api.themoviedb.org/3/person/\(id)/external_ids?api_key=821fba2e86cbb574aecf827d251585b9"
        if let url = URL(string: actrosMoviesURL) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)
                    return
                }
                if let safeData = data {
//                    print(String(data: safeData, encoding: .utf8)!)
                    let decoder = JSONDecoder()
                    do {
                        
                        let decodedData = try decoder.decode(ActorsSocialMediaModel.self, from: safeData)
                        DispatchQueue.main.async {
                            completion(decodedData)
                        }
                        
                    } catch {
                        print("Error: \(error)")
                    }
                }
            }
            task.resume()
        }
    }
    
    
    
    
//https://api.themoviedb.org/3/person/1190668/images?api_key=821fba2e86cbb574aecf827d251585b9 - actor images
//https://api.themoviedb.org/3/person/1190668/movie_credits?api_key=821fba2e86cbb574aecf827d251585b9 - actors movies

    
    
}
