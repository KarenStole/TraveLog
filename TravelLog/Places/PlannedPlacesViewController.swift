//
//  PlannedPlacesViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/23/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class PlannedPlacesViewController: UIViewController {
    let modelController = ModelManager.sharedModelManager
    var visitedPlaces : [VisitedPlaces] = []
    var place : Place?

    @IBOutlet weak var plannedPlacesCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        modelController.getPlacesFromDatabase(completion: { places, error in
            if let places = places{
                self.modelController.getPlacesIDPlanedByUID(uid: self.modelController.userID, places: places, completion: { visitedPlaces, error in
                    if let visitedPlace = visitedPlaces{
                        self.visitedPlaces = visitedPlace
                        self.plannedPlacesCollectionView.reloadData()
                    }
                    if let error = error{
                        let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                        self.present(alert, animated: true)
                        print("LOG ERROR: Error loading plannedPlaces: \(error.localizedDescription)")
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
        // Do any additional setup after loading the view.
    }
    @IBAction func goToMap(_ sender: Any) {
        performSegue(withIdentifier: "goToMap", sender: self)
    }
}


extension PlannedPlacesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(visitedPlaces.count == 0){
            return 1
        }
        else{
            return visitedPlaces.count

        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitedCell", for: indexPath) as! MyPlacesCollectionViewCell
        if(visitedPlaces.count != 0){
            cell.placeImageView.kf.setImage(with: URL(string: visitedPlaces[indexPath.row].places.photos[0]))
            cell.placeNameLabel.text = visitedPlaces[indexPath.row].places.name
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM,yyyy"
            cell.visitDateLabel.text = dateFormatterPrint.string(from: visitedPlaces[indexPath.row].date)
        }else{
            cell.placeImageView.kf.setImage(with: URL(string: "https://cdn.dribbble.com/users/24885/screenshots/1797793/events-empty-data-set_1x.png"))
            cell.placeNameLabel.text = ""
            cell.visitDateLabel.text = ""
        }

        
        
        
        
        return cell
    }
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
        if(visitedPlaces.count != 0){
        place = visitedPlaces[indexPath.row].places
            performSegue(withIdentifier: "goToPlaceDetail", sender: self)
        }
    }

    
}
