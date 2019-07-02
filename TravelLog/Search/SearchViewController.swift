//
//  SearchViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Kingfisher

class SearchViewController: UIViewController {
    let modelController = ModelManager.sharedModelManager
    var listOfCountries: [Country] = []
    var listOfPlaces: [Place] = []
    var searchCountry = [String]()
    var searchActive : Bool = false
    var currentCountry : Country? = nil

    @IBOutlet weak var countryTableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    
}
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer =     UITapGestureRecognizer(target: self, action:    #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        modelController.getCountriesFromDatabase (completion: { countries, error in
            if let countries = countries{
                self.listOfCountries = countries
                self.countryTableView.reloadData()
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading countries: \(error.localizedDescription)")
            }
            
        })
        modelController.getPlacesFromDatabase(completion: { places, error in
            if let places = places{
                self.listOfPlaces = places
                self.countryTableView.reloadData()
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading places: \(error.localizedDescription)")
            }
            
        })
    }
    }


extension SearchViewController: UITableViewDataSource, UITableViewDelegate, DetailTableViewCellDelegate {
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(searchActive){
            return searchCountry.count
        }
        else{
            return listOfCountries.count
        }

    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "countryCell", for: indexPath) as! CountryTableViewCell
        if(searchActive){
            for countries in listOfCountries{
                for contryName in searchCountry{
                    if(contryName == countries.name){
                        let placesOfTheCountry = self.listOfPlaces.filter { (arg0) -> Bool in
                            let (country) = arg0
                            return country.countryID == countries.id
                        }
                        cell.country = countries
                        cell.countryImageView.kf.setImage(with: URL(string: countries.photos[0]))
                        cell.countryNameLabel.text = countries.name
                        countries.places = placesOfTheCountry
                        cell.descriptionLabel.text = countries.description
                        cell.delegate = self as? DetailTableViewCellDelegate
                    }
                }
            }
        }
        else{
            let placesOfTheCountry = self.listOfPlaces.filter { (arg0) -> Bool in
                let (country) = arg0
                return country.countryID == listOfCountries[indexPath.row].id
            }
                cell.country = listOfCountries[indexPath.row]
                cell.countryImageView.kf.setImage(with: URL(string: listOfCountries[indexPath.row].photos[0]))
                cell.countryNameLabel.text = listOfCountries[indexPath.row].name
                listOfCountries[indexPath.row].places = placesOfTheCountry
                cell.descriptionLabel.text = listOfCountries[indexPath.row].description
            cell.delegate = self as? DetailTableViewCellDelegate
            }
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 107.0;//Choose your custom row height
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is CountryViewController{
            let destinationVC = segue.destination as! CountryViewController
            destinationVC.country = currentCountry
        }
        
    }
    func goToDetail(cell: CountryTableViewCell) {
        let indexPath = countryTableView.indexPath(for: cell)
        if let indexPath = indexPath {
            let cell = countryTableView.cellForRow(at: indexPath) as! CountryTableViewCell
            currentCountry = cell.country
            
            performSegue(withIdentifier: "goToCountryView", sender: self)
        }
    }
    
    
}

extension SearchViewController : UISearchBarDelegate{
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        searchCountry = modelController.getCountriesName(countries: listOfCountries).filter({ $0.prefix(searchText.count) == searchText })
        if(searchCountry.count != listOfCountries.count){
            searchActive = true}
        else{
            searchActive = false}
        countryTableView.reloadData()
    }
    
}
