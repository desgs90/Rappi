//
//  ViewController.swift
//  RappiMovies
//
//  Created by Diego Eduardo on 11/6/22.
//

import UIKit

class HomeViewController: UIViewController {
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var selectLanguageView: UIView!
    @IBOutlet weak var selectYearView: UIView!
    @IBOutlet weak var selectLanguageLabel: UILabel!
    @IBOutlet weak var recomendedColelctionView: UICollectionView!
    @IBOutlet weak var selectYearLabel: UILabel!
    private let viewModel: HomeViewModel = .shared
    private var picker: UIPickerView?
    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.title = "eMovie"
        // Do any additional setup after loading the view.
        viewModel.delegate = self
        
        homeTableView.delegate = self
        homeTableView.dataSource = self
        homeTableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: "HomeTableViewCell")
        
        recomendedColelctionView.delegate = self
        recomendedColelctionView.dataSource = self
        recomendedColelctionView.register(UINib(nibName: "HomeCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "HomeCollectionViewCell")
        
        selectYearView.roundCorners(15)
        selectYearView.layer.borderWidth = 1
        selectYearView.layer.borderColor = UIColor.white.cgColor
        let selectYearTapped = UITapGestureRecognizer(target: self, action: #selector(selectYearTapped(_:)))
        selectYearView.addGestureRecognizer(selectYearTapped)

        
        selectLanguageView.roundCorners(15)
        selectLanguageView.layer.borderWidth = 0.5
        selectLanguageView.layer.borderColor = UIColor.white.cgColor
        let selectLanguageTapped = UITapGestureRecognizer(target: self, action: #selector(selectLanguageTapped(_:)))
        selectLanguageView.addGestureRecognizer(selectLanguageTapped)
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.movieSelected(_:)), name: NSNotification.Name(rawValue: movieSelectedNotificationName), object: nil)

        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.view.backgroundColor = .black
    }
}

//MARK: - NOTIFICATION ACTION
extension HomeViewController {
    @objc
    private func movieSelected(_ notification: NSNotification) {
        
        if let movieSelected = notification.userInfo?["movie"] as? Movie {
            performSegue(withIdentifier: "goToMoviewDetails", sender: movieSelected)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let moview = sender as? Movie {
            let moviewModelDetail: MoviewDetailsViewModel = .shared
            moviewModelDetail.setSelectedMovie(moview)
        }
    }
}
// MARK: - Actions
extension HomeViewController {
    @objc
    private func selectYearTapped(_ sender: UITapGestureRecognizer) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 200
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Seleccione año", message: "", preferredStyle: .alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if pickerView.selectedRow(inComponent: 0) == 0 {
                self.setRecomendedYear("0")
                self.selectYearLabel.text = "Año"
            } else {
                let yearSelected = yearsAvailable[pickerView.selectedRow(inComponent: 0)-1]
                self.selectYearLabel.text = yearSelected
                self.setRecomendedYear(yearSelected)
            }
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    
    @objc
    private func selectLanguageTapped(_ sender: UITapGestureRecognizer) {
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIPickerView(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.delegate = self
        pickerView.dataSource = self
        pickerView.tag = 100
        vc.view.addSubview(pickerView)
        let editRadiusAlert = UIAlertController(title: "Seleccione Idioma", message: "", preferredStyle: .alert)
        editRadiusAlert.setValue(vc, forKey: "contentViewController")
        editRadiusAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { action in
            if pickerView.selectedRow(inComponent: 0) == 0 {
                self.setRecomendedLanguage("")
                self.selectLanguageLabel.text = "Idioma"
            } else {
                let language = laguagesAvailable[pickerView.selectedRow(inComponent: 0)-1]
                self.selectLanguageLabel.text = language
                self.setRecomendedLanguage(language)
            }
        }))
        editRadiusAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(editRadiusAlert, animated: true)
    }
    
    private func setRecomendedYear(_ year: String) {
        viewModel.setRecomndedYear(year)
    }
    
    private func setRecomendedLanguage(_ language: String) {
        viewModel.setRecomndedLanguage(language)
    }
}
extension HomeViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 100 {
            return laguagesAvailable.count+1
        }
        return yearsAvailable.count+1
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if row == 0 {
            return "Todos"
        }
        if pickerView.tag == 100 {
            return laguagesAvailable[row-1]
        }
        return yearsAvailable[row-1]
    }
}

//MARK: - TABLE VIEW DELEGATE
extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as? HomeTableViewCell else {
            return UITableViewCell()
        }
        let section = indexPath.section
        
        if section == 0 {
            cell.setMoviusToShow(viewModel.getUpcomingMovies())
        }
        
        if section == 1 {
            cell.setMoviusToShow(viewModel.getTpRatedMovies())
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 190
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 20))
        let label = UILabel(frame: headerView.frame)
        label.textColor = .white
        label.font = UIFont(name: "Arial Rounded MT Bold", size: 18)
        if section == 0 {
            label.text = "Proximos estrnenos"
            headerView.addSubview(label)
            return headerView
        }
        if section == 1 {
            label.text = "Tendencias"
            headerView.addSubview(label)
            return headerView
        }
        return nil
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 20
    }
}

//MARK: - COLLECTION VIEW
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "HomeCollectionViewCell", for: indexPath) as? HomeCollectionViewCell else {
            return UICollectionViewCell()
        }
        let movie = viewModel.getRecomendedMovies()[indexPath.row]
        if let image = movie.poster_path {
            cell.backgroundImage.downloaded(from: "https://image.tmdb.org/t/p/w500\(image)")
        }
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.getRecomendedMovies().count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 160, height: 180)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let movie = viewModel.getRecomendedMovies()[indexPath.item]
        let userInfo = ["movie": movie]
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: movieSelectedNotificationName), object: nil, userInfo: userInfo)
    }
}


//MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func updateUpcomingMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadSections(IndexSet(integer: 0), with: .fade)
        }
        
    }
    
    func updateTopRatedMovues() {
        DispatchQueue.main.async { [weak self] in
            self?.homeTableView.reloadSections(IndexSet(integer: 1), with: .fade)
        }
    }
    
    func showErrorFor(_ type: RequestType) {
        DispatchQueue.main.async { [weak self] in
            let alert = UIAlertController(title: "Error", message: "Error loading movies", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .destructive))
            self?.present(alert, animated: true)
        }
    }
    
    func updateRecomendedMovies() {
        DispatchQueue.main.async { [weak self] in
            self?.recomendedColelctionView.reloadData()
        }
    }
}


