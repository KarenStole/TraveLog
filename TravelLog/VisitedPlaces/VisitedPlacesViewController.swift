//
//  VisitedPlacesViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//
/*
 View Controller in charge of present the views of the Visited Places section.
 List the places which the user visited before
 */
import UIKit
import FirebaseAuth

class VisitedPlacesViewController: UIViewController {
    let modelController = ModelManager.sharedModelManager
    var visitedPlaces : [VisitedPlaces] = []
    var place : Place?
    
    @IBOutlet weak var placesVisitedCollectionView: UICollectionView!
    
    @IBOutlet weak var noPlacesVisitedLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    /*
     Get the list of visited places from firebase database.
     If there is no results, no result's label is shown.
     If an error comes, an alert is shown
     */
    override func viewWillAppear(_ animated: Bool) {
        modelController.userID = (Auth.auth().currentUser?.uid)!
        noPlacesVisitedLabel.isHidden = true
        modelController.getPlacesFromDatabase(completion: { places, error in
            if let places = places{
                self.modelController.getPlacesIDVisitedByUID(uid: self.modelController.userID, places: places, completion: { visitedPlaces, error in
                    if let visitedPlace = visitedPlaces{
                        if(visitedPlace.isEmpty){
                            self.noPlacesVisitedLabel.isHidden = false
                        }
                        self.visitedPlaces = visitedPlace
                        self.placesVisitedCollectionView.reloadData()
                    }
                    if let error = error{
                        self.noPlacesVisitedLabel.isHidden = false
                        let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print("LOG ERROR: Error loading visitedPlaces: \(error.localizedDescription)")
                    }
                    
                }
                )
                
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading places: \(error.localizedDescription)")
            }
            
        })
    }
    
    @IBAction func goToMap(_ sender: Any) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
}
extension VisitedPlacesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return visitedPlaces.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitedCell", for: indexPath) as! MyPlacesCollectionViewCell
        cell.placeImageView.kf.setImage(with: URL(string: visitedPlaces[indexPath.row].places.photos[0]))
        cell.placeNameLabel.text = visitedPlaces[indexPath.row].places.name
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        cell.visitDateLabel.text = dateFormatterPrint.string(from: visitedPlaces[indexPath.row].date)
        return cell
    }
    
    /*
     This VC shows two differets VC depends from the option selected.
     If the Map's button is touched, MapViewController is shown passing the list of visited places.
     If a cell is touched, PlaceViewController to show the information of the place
     */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PlaceViewController{
            let destinationVC = segue.destination as! PlaceViewController
            destinationVC.place = place
        }
        if segue.destination is MapViewController{
            let destinationVC = segue.destination as! MapViewController
            destinationVC.places = visitedPlaces
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        place = visitedPlaces[indexPath.row].places
        performSegue(withIdentifier: "goToPlaceDetail", sender: self)
    }
    
}
