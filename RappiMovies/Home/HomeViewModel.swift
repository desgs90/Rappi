//
//  HomeViewModel.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import Foundation


protocol HomeViewModelDelegate: AnyObject {
    func updateUpcomingMovies()
    func updateTopRatedMovues()
    func showErrorFor(_ type: RequestType)
    func updateRecomendedMovies()
}

class HomeViewModel {
    static let shared = HomeViewModel()
    weak var delegate: HomeViewModelDelegate?
    
    private let network: NetworkHandler = .shared
    
    private var topRatedMovies = [Movie]() {
        didSet {
            if let _ = delegate {
                delegate?.updateTopRatedMovues()
            }
        }
    }
    private var upcomingMovies = [Movie]() {
        didSet {
            if let _ = delegate {
                delegate?.updateUpcomingMovies()
            }
        }
    }
    private var recomendedMovies = [Movie]() {
        didSet {
            updateYearAndLanguages()
        }
    }
    
    private var recomendedLanguage = "" {
        didSet {
            self.updateRecomendedMovies()
        }
    }
    private var recomendedYear = 0 {
        didSet {
            self.updateRecomendedMovies()
        }
    }
    
    private init (){
        network.delegate = self
        network.getMoviewForType(.UpComing)
        network.getMoviewForType(.TopRated)
    }
}
//MARK: - GET MOVIES
extension HomeViewModel {
    func setRecomndedYear(_ value: String) {
        if let v = Int(value) {
            recomendedYear = v
        }
    }
    
    func setRecomndedLanguage(_ value: String) {
        if value.lowercased().elementsEqual("todos") {
            recomendedLanguage = ""
        } else {
            recomendedLanguage = value
        }
    }
}

//MARK: - GET MOVIES
extension HomeViewModel {
    func getUpcomingMovies() -> [Movie] {
        return self.upcomingMovies
    }
    func getTpRatedMovies() -> [Movie] {
        return self.topRatedMovies
    }
    func getRecomendedMovies() -> [Movie] {
        if self.recomendedMovies.count > 6 {
            return  Array(self.recomendedMovies.prefix(upTo: 6))
        }
        return self.recomendedMovies
    }
}
//MARK: - CREATE RECOMENDED MOVIES
extension HomeViewModel{
    private func updateYearAndLanguages() {
        let dates = topRatedMovies.compactMap({$0.release_date}).uniqued()
        let languages = topRatedMovies.compactMap({$0.original_language}).uniqued()
        laguagesAvailable = languages
        laguagesAvailable = laguagesAvailable.sorted()
        yearsAvailable.removeAll()
        for date in dates {
            let year = date.prefix(4)
            yearsAvailable.append("\(year)")
        }
        yearsAvailable = yearsAvailable.uniqued()
        yearsAvailable = yearsAvailable.sorted()
    }
    private func updateRecomendedMovies() {
        var filtered = topRatedMovies
        
        
        if recomendedLanguage.isEmpty && recomendedYear == 0 {
            recomendedMovies = filtered
        } else {
            filtered.removeAll()
            if !recomendedLanguage.isEmpty {
                filtered = topRatedMovies.filter({$0.original_language == recomendedLanguage})
            }
            
            if recomendedYear > 0 {
                let baseSOurce = recomendedLanguage.isEmpty ? topRatedMovies:filtered
                for movie in baseSOurce {
                    if let date = movie.release_date {
                        if date.contains("\(recomendedYear)") {
                            filtered.append(movie)
                        } else {
                            if !recomendedLanguage.isEmpty {
                                filtered.removeAll(where: {$0.id == movie.id})
                            }
                        }
                    }
                }
            }
            recomendedMovies = filtered.uniqued()
                
        }
        
        
        if let _ = delegate {
            delegate?.updateRecomendedMovies()
        }
    }
}

//MARK: - NetworkHandlerDelegate
extension HomeViewModel: NetworkHandlerDelegate {
    func updateMoviesFor(_ response: MoviesResponse, _ type: RequestType) {
        if type == .UpComing {
            upcomingMovies = response.results
            return
        }
        topRatedMovies = response.results
        updateRecomendedMovies()
    }
    
    func getVideoDetails(_ video: Video) {
        
    }
    
    func errorDownloadingMovies(_ type: RequestType) {
        
    }
}
