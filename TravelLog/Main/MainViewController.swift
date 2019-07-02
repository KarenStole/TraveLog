//
//  MainViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Kingfisher
import UserNotifications

class MainViewController: UIViewController {
    let manager = LocalNotificationManager()
    let modelManager = ModelManager.sharedModelManager
    var recommendedPlace : [Place] = []
    var place : Place?
    @IBOutlet weak var recomendatonCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        var count = 0
        let calendar1 = Calendar.current
        modelManager.getPlacesFromDatabase(completion: {places, error in
            if let places = places {
                self.modelManager.getPlacesIDPlanedByUID(uid: self.modelManager.userID, places: places, completion: {plannedPlaces, error in
                    if let plannedPlaces = plannedPlaces{
                        
                        for date in plannedPlaces{
                            self.manager.notifications.append(Notification(id: "reminder-\(count)", title: "You have planned to visit \(date.places.name) today! Enjoy it!", datetime: DateComponents(calendar: Calendar.current, year: calendar1.component(.year, from: date.date), month: calendar1.component(.month, from: date.date), day: calendar1.component(.day, from: date.date), hour: calendar1.component(.hour, from: Date()), minute:calendar1.component(.minute, from: Date())+1 )))
                            count += 1
                        }
                        self.manager.schedule()
                    }
                    
                })
            }
        })

    }
    override func viewWillAppear(_ animated: Bool) {
        //manager.notifications = []
        
        modelManager.getNoVisitedPlacesVisitedOrPlanned(completion: {place, error in
            if let place = place{
                if(!(place.isEmpty)){
                    self.recommendedPlace = place
                    self.recomendatonCollectionView.reloadData()
                }else{
                    self.modelManager.getPlacesFromDatabase(completion: {places, error in
                        if let places = places{
                            self.recommendedPlace = Array(places.prefix(10))
                            self.recomendatonCollectionView.reloadData()
                        }
                    })
                }
            }
            if let error = error{
                let alert = UIAlertController(title: "Something went wrong!", message: "Sorry, we're having some problems. Retry in some minutes", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
                self.present(alert, animated: true)
                print("LOG ERROR: Error loading recommended places: \(error.localizedDescription)")
            }
        })
        

    }
    
    @IBAction func logOut(_ sender: Any) {
        modelManager.signOut()
        performSegue(withIdentifier: "goToLogin", sender: self)
    }
    

}

extension MainViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return recommendedPlace.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "recomCell", for: indexPath) as! RecomendationCollectionViewCell
        cell.place = recommendedPlace[indexPath.row]
        cell.placeImageView.kf.setImage(with: URL(string: recommendedPlace[indexPath.row].photos[0]))
        cell.placeNameLabel.text = recommendedPlace[indexPath.row].name
        cell.placeDescLabel.text = recommendedPlace[indexPath.row].description
        
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.destination is PlaceViewController){
            let destinationVC = segue.destination as! PlaceViewController
            destinationVC.place = place
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        place = recommendedPlace[indexPath.row]
        performSegue(withIdentifier: "goToPlace", sender: self)
    }
    
}
