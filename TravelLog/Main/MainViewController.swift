//
//  MainViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import Kingfisher

class MainViewController: UIViewController {
    let modelManager = ModelManager.sharedModelManager
    var recommendedPlace : [Place] = []
    var place : Place?
    @IBOutlet weak var recomendatonCollectionView: UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
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
            }})
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
        
            let destinationVC = segue.destination as! PlaceViewController
            destinationVC.place = place
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        place = recommendedPlace[indexPath.row]
        performSegue(withIdentifier: "goToPlace", sender: self)
    }
    
}
