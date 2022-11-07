//
//  HomeCollectionViewCell.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import UIKit

class HomeCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var backgroundImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        resetUI()
    }
    
    override func prepareForReuse() {
        resetUI()
    }
    private func resetUI() {
        backgroundImage.image = UIImage(systemName: "rays")
    }
}
