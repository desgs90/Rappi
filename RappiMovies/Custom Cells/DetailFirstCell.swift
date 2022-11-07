//
//  DetailFirstCell.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import UIKit

class DetailFirstCell: UITableViewCell {

    @IBOutlet weak var movieRating: UILabel!
    @IBOutlet weak var moviewYear: UILabel!
    @IBOutlet weak var moviewLanguage: UILabel!
    @IBOutlet weak var movieName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
