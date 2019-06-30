//
//  PlaceViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/23/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import MapKit

class PlaceViewController: UIViewController {

    var place : Place?
    var modelController = ModelManager.sharedModelManager
    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var visitedButton: UIButton!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ubicationMapView: MKMapView!
    @IBOutlet weak var pageControl: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        ubicationMapView.layer.borderWidth = 2.0
        ubicationMapView.layer.borderColor = UIColor(red:255/255.0, green:135.0/255.0, blue:107.0/255.0, alpha: 1.0).cgColor
        let initialLocation = CLLocation(latitude: (place?.lat)!, longitude: (place?.long)!)
        centerMapOnLocation(location: initialLocation)
        annotation.coordinate = CLLocationCoordinate2D(latitude: (place?.lat)!, longitude: (place?.long)!)
        annotation.title = place?.name
        ubicationMapView.addAnnotation(annotation)
        placeNameLabel.text = place?.name
        descriptionText.text = place?.description

    }
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        ubicationMapView.setRegion(coordinateRegion, animated: true)
    }

    @IBAction func setVisitedPlace(_ sender: Any) {
        var dateSelected = Date()
            let vc = UIViewController()
            vc.preferredContentSize = CGSize(width: 250,height: 300)
            let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
            pickerView.datePickerMode = UIDatePicker.Mode.date
            pickerView.maximumDate = dateSelected
            vc.view.addSubview(pickerView)

            let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
                UIAlertAction in
                dateSelected = pickerView.date
                let placeVisited = VisitedPlaces(date: dateSelected, places: self.place!)
                self.modelController.updateVisitedPlaces(place: placeVisited, completion: { bool, error in
                    if (error != nil){
                        print("Error while updating visited place: \(String(describing: error?.localizedDescription))")
                    }
                    if let bool = bool {
                        if (!bool){
                            self.modelController.saveVisitedPlaces(place: placeVisited)
                        }
                    }
                })
                self.modelController.deletePlannedPlace(place: placeVisited, completion: { bool, error in
                    if (error != nil){
                        print("Error while removing planned place: \(String(describing: error?.localizedDescription))")
                    }
                })

            }
            let editUnitsAlert = UIAlertController(title: "Select the visited date", message: "", preferredStyle: UIAlertController.Style.alert)
            editUnitsAlert.setValue(vc, forKey: "contentViewController")
            editUnitsAlert.addAction(doneAction)
            editUnitsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            present(editUnitsAlert, animated: true)
       
    }
    @IBAction func setPlannedPlace(_ sender: Any) {
        
        
        var dateSelected = Date()
        let vc = UIViewController()
        vc.preferredContentSize = CGSize(width: 250,height: 300)
        let pickerView = UIDatePicker(frame: CGRect(x: 0, y: 0, width: 250, height: 300))
        pickerView.datePickerMode = UIDatePicker.Mode.date
        pickerView.minimumDate = dateSelected
        vc.view.addSubview(pickerView)
        
        let doneAction = UIAlertAction(title: "Done", style: UIAlertAction.Style.default) {
            UIAlertAction in
            dateSelected = pickerView.date
            let placeVisited = VisitedPlaces(date: dateSelected, places: self.place!)
            self.modelController.updatePlannedPlaces(place: placeVisited, completion: { bool, error in
                if (error != nil){
                    print("Error while updating visited place: \(String(describing: error?.localizedDescription))")
                }
                if let bool = bool {
                    if (!bool){
                        self.modelController.savePlannedPlaces(place: placeVisited)
                    }
                }
            })
            self.modelController.deletePlannedPlace(place: placeVisited, completion: { bool, error in
                if (error != nil){
                    print("Error while removing planned place: \(String(describing: error?.localizedDescription))")
                }
            })
            
        }
        let editUnitsAlert = UIAlertController(title: "Select the visited date", message: "", preferredStyle: UIAlertController.Style.alert)
        editUnitsAlert.setValue(vc, forKey: "contentViewController")
        editUnitsAlert.addAction(doneAction)
        editUnitsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.present(editUnitsAlert, animated: true)
        }
        
        modelController.wasPlacePlannedBefore(place: place!, completion: { date, error in
            if let date = date {
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd MMM,yyyy"
                let formatDate = dateFormatterPrint.string(from: date)
                let questionAlert = UIAlertController(title: "You have already planned it!", message: "You have schedule your visit to \(self.place!.name) on \(formatDate). Do you want to reschedule it?", preferredStyle: UIAlertController.Style.alert)
                questionAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                questionAlert.addAction(yesAction)
                pickerView.setDate(date, animated: true)
                self.present(questionAlert, animated: true)
            }
            else{
                self.present(editUnitsAlert, animated: true)
            }
            
        })
    }
}

extension PlaceViewController : UICollectionViewDelegate, UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return place?.photos.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeImageCell", for: indexPath) as! PlaceImagesCollectionViewCell
        cell.placeImageView.kf.setImage(with: URL(string: (place?.photos[indexPath.row])!))
            return cell
        
    }
}
