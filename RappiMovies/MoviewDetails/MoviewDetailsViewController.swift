//
//  MoviewDetailsViewController.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import Foundation
import UIKit

class MoviewDetailsViewController: UIViewController {
    private let viewModel: MoviewDetailsViewModel = .shared
    @IBOutlet weak var detailsTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "eMovie"
        
        detailsTableView.delegate = self
        detailsTableView.dataSource = self
        detailsTableView.register(UINib(nibName: "DetailFirstCell", bundle: nil), forCellReuseIdentifier: "DetailFirstCell")
        viewModel.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        let imageView = UIImageView(frame: UIScreen.main.bounds)
        if let image = viewModel.getPictureAddress() {
            imageView.downloaded(from: "https://image.tmdb.org/t/p/w500\(image)")
        }
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        
        let view = UIView(frame: imageView.frame)
        view.backgroundColor = UIColor.blend(color1: .black, intensity1: 9, color2: .red, intensity2: 0.7)
        view.alpha = 0.6
        self.view.addSubview(view)
        self.view.sendSubviewToBack(imageView)
        self.view.bringSubviewToFront(detailsTableView)
    }
}
extension MoviewDetailsViewController: MoviewDetailsViewModelDelegate {
    func navigateToVideo(_ videoKey: String) {
        DispatchQueue.main.async {
            
            
            let youtubeId = videoKey
            var youtubeUrl = NSURL(string:"youtube://\(youtubeId)")!
            if UIApplication.shared.canOpenURL(youtubeUrl as URL){
                UIApplication.shared.open(youtubeUrl as URL)
            } else{
                youtubeUrl = NSURL(string:"https://www.youtube.com/watch?v=\(youtubeId)")!
                UIApplication.shared.open(youtubeUrl as URL)
            }
        }
    }
    
    func errornavigationToTriler() {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Error cargando video", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
            self?.present(alert, animated: true)
        }
    }
    
    
}

//MARK: - TABLE VIEW DELEGATE
extension MoviewDetailsViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let row = indexPath.row
        
        if row == 0 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "DetailFirstCell") as? DetailFirstCell else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            if let name = viewModel.getName() {
                cell.movieName.text = name
            }
            if let year = viewModel.getYear() {
                cell.moviewYear.text = year
            }
            
            if let lang = viewModel.getLanguage() {
                cell.moviewLanguage.text = lang
            }
            if let rat = viewModel.getRating() {
                cell.movieRating.text = "★ \(rat)"
            }
            return cell
        }
        if row == 1 {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTrillerCell") else {
                return UITableViewCell()
            }
            cell.selectionStyle = .none
            cell.backgroundColor = .clear
            cell.textLabel?.text = "Ver Trailer"
            cell.textLabel?.textColor = .white
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.layer.borderWidth = 1
            cell.textLabel?.layer.borderColor = UIColor.white.cgColor
            cell.textLabel?.roundCorners(15)
            
            return cell
        }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ViewTrillerCell") else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.backgroundColor = .clear
        if let text = viewModel.getOverview() {
            cell.textLabel?.text = text
            cell.textLabel?.numberOfLines = 50
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        }
        cell.textLabel?.textColor = .white
        cell.textLabel?.textAlignment = .center
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let row = indexPath.row
        if row == 0 {
            return self.view.frame.height - 200
        }
        if row == 1 {
            return 45
        }
        if let detail = viewModel.getOverview() {
            let height = detail.size(font: UIFont.systemFont(ofSize: 26), width: tableView.frame.width)
            return height.height
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 1 {
            viewModel.getTrilerInfo()
        }
    }
}
