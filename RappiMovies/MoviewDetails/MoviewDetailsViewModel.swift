//
//  MoviewDetailsViewModel.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import Foundation

protocol MoviewDetailsViewModelDelegate: AnyObject {
    func navigateToVideo(_ videoKey: String)
    func errornavigationToTriler() 
}
class MoviewDetailsViewModel {
    private var movieSelected: Movie?
    static let shared = MoviewDetailsViewModel()
    private let network: NetworkHandler = .shared
    weak var delegate: MoviewDetailsViewModelDelegate?
    private init(){}
}

extension MoviewDetailsViewModel {
    func setSelectedMovie(_ movie: Movie) {
        self.movieSelected = movie
    }
}

extension MoviewDetailsViewModel {
    func getPictureAddress() -> String? {
        if let moview = self.movieSelected {
            if let image = moview.poster_path {
                return image
            }
        }
        return nil
    }
    
    func getName() -> String? {
        if let movie = movieSelected {
            if let name = movie.title {
                return name
            }
            if let name = movie.original_title {
                return name
            }
        }
        return nil
    }
    
    func getLanguage() -> String? {
        if let moview = self.movieSelected {
            if let lang = moview.original_language {
                return lang
            }
        }
        return nil
    }
    
    func getRating()-> Float? {
        if let moview = self.movieSelected {
            if let r = moview.vote_average {
                return r
            }
        }
        return nil
    }
    func getYear() -> String? {
        if let moview = self.movieSelected {
            if let year = moview.release_date {
                return "\(year.prefix(4))"
            }
        }
        return nil
    }
    
    func getOverview() -> String? {
        if let moview = self.movieSelected {
            if let detail = moview.overview {
                return detail
            }
        }
        return nil
    }
}


extension MoviewDetailsViewModel {
    func getTrilerInfo() {
        if let mov = movieSelected {
            if let id = mov.id {
                network.getMoviewTrailerInfo("\(id)") { [weak self] response in
                    switch response {
                    case .success(let response):
                        self?.getVideoKey(response)
                        break
                    case .failure(_):
                        self?.delegate?.errornavigationToTriler()
                        break
                    }
                }
            }
        }
    }
    
    private func getVideoKey(_ videos: VideoResponse) {
        guard let del = delegate else {
            return
        }
        let options = videos.results
        var key = ""
        let youTubeOptions = options.filter({$0.site?.lowercased() == "youtube"})
        var toShow = youTubeOptions.filter({$0.official == true})
        if toShow.isEmpty {
            toShow = youTubeOptions
        }
        if let first = toShow.first {
            if let key = first.key {
                del.navigateToVideo(key)
                return
            }
        }
        
        del.errornavigationToTriler()
    }
}
