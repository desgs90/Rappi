//
//  HomeTableViewCell.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import UIKit

class HomeTableViewCell: UITableViewCell {

    @IBOutlet weak var cellColelctionView: UICollectionView!
    private var movies = [Movie]()
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        cellColelctionView.delegate = self
        cellColelctionView.dataSource = self
        cellColelctionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        resetCell()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    override func prepareForReuse() {
        resetCell()
    }
    private func resetCell() {
        movies.removeAll()
    }
    func setMoviusToShow(_ movies: [Movie]) {
        self.movies = movies
        self.cellColelctionView.reloadData()
    }
}

//MARK: - COLLECTION VIEW
extension HomeTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = movies[indexPath.item]
        if let image = movie.poster_path {
            cell.backgroundImage.downloaded(from: "https://image.tmdb.org/t/p/w500\(image)")
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return movies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = movies[indexPath.item]
        let userInfo = ["movie": movie]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: movieSelectedNotificationName), object: nil, userInfo: userInfo)
    }
}
