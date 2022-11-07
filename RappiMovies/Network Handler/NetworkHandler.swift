//
//  NetworkHandler.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import Foundation

protocol NetworkHandlerDelegate: AnyObject {
    func updateMoviesFor(_ response: MoviesResponse, _ type: RequestType)
    func getVideoDetails(_ video: Video)
    func errorDownloadingMovies(_ type: RequestType)
}
/*
 UPCOMING
https://api.themoviedb.org/3/movie/upcoming?api_key=3b464975cba5ed2201b47782eeacf206&language=en-US&
 MOVIE DETAILS
https://api.themoviedb.org/3/movie/{movide_id}/videos?api_key=3b464975cba5ed2201b47782eeacf206&language=en-US
 TOP RATED USE THIS FILTERING YEAR AND LANGUAGE FOR RECOMMENDED
https://api.themoviedb.org/3/movie/top_rated?api_key=3b464975cba5ed2201b47782eeacf206&language=en-US
 TRAILER API
https://www.youtube.com/watch?v={key}
 IMAGES API
https://image.tmdb.org/t/p/w500/{imageID}
 
 
 */
class NetworkHandler {
    static let shared = NetworkHandler()
    weak var delegate: NetworkHandlerDelegate?
    
    private let api_key = "3b464975cba5ed2201b47782eeacf206"
    
    private init(){}
}


extension NetworkHandler {
    func getMoviewForType(_ type: RequestType) {
        guard let del = delegate else {
            return
        }
        let requestType = type == .TopRated ? "top_rated":"upcoming"
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(requestType)?api_key=\(api_key)&language=en-US") else {
            del.errorDownloadingMovies(type)
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                del.errorDownloadingMovies(type)
                return
            }
            guard let data = data else {
                del.errorDownloadingMovies(type)
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(MoviesResponse.self, from: data)
                del.updateMoviesFor(parsedData, type)
            } catch {
                del.errorDownloadingMovies(type)
            }
        }.resume()
    }
    
    func getMoviewTrailerInfo(_ moviewID: String,completion: @escaping ((Result<VideoResponse, Error>)) -> () ) {
        guard let url = URL(string: "https://api.themoviedb.org/3/movie/\(moviewID)/videos?api_key=\(api_key)&language=en-US") else {
            completion(.failure(APIErrors.APIError))
            return
        }
        
        var request = URLRequest(url: url)
        request.cachePolicy = .returnCacheDataElseLoad
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            if let _ = error {
                completion(.failure(APIErrors.APIError))
                return
            }
            guard let data = data else {
                completion(.failure(APIErrors.APIError))
                return
            }
            do {
                let parsedData = try JSONDecoder().decode(VideoResponse.self, from: data)
                completion(.success(parsedData))
            } catch {
                completion(.failure(APIErrors.APIError))
            }
        }.resume()
    }
}


enum RequestType {
    case TopRated, UpComing
}
enum APIErrors: Error {
    case APIError
}
