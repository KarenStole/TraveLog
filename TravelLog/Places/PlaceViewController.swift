//
//  PlaceViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/23/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import MapKit
import FirebaseAuth
/*
 VC that show all the details of a place:
 Ubication, images, name and description.
 */
class PlaceViewController: UIViewController {

    var place : Place?
    var modelController = ModelManager.sharedModelManager
    let regionRadius: CLLocationDistance = 1000
    let annotation = MKPointAnnotation()
    var timer = Timer()
    var count = 0

    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var imagesCollectionView: UICollectionView!
    @IBOutlet weak var visitedButton: UIButton!
    @IBOutlet weak var planButton: UIButton!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var ubicationMapView: MKMapView!
    @IBOutlet weak var pageControl: UIPageControl!
    
    /*
     Setting the views values, such as labels values, map annotations, and automatic banner
     */
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
        pageControl.numberOfPages = (place?.photos.count)!
        pageControl.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }

    }
    /*
     Getting the current user id in orther to mark the place to visited or
     to schedule a trip
     */
    override func viewWillAppear(_ animated: Bool) {
        modelController.userID = (Auth.auth().currentUser?.uid)!
    }
    
    /*
     Center the map in the annotaton in a specific radius
     */
    func centerMapOnLocation(location: CLLocation) {
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        ubicationMapView.setRegion(coordinateRegion, animated: true)
    }
    
    /*
     Change the image from the slider of the VC automaticlly
     */
    @objc func changeImage(){
        if count < (place?.photos.count)!{
            let index = IndexPath.init(item: count, section: 0)
            self.imagesCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageControl.currentPage = count
            count += 1
        }else{
            count = 0
            let index = IndexPath.init(item: count, section: 0)
            self.imagesCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageControl.currentPage = count
            count = 1
        }
    }
/*
     Action of the Visited's button.
     If the place was visited before, it update the date form the DB (a pickerview is shown in order to choose the date)
     If the place was planned, automacticlly seted as visited
     If the place was not visited nither planned, just add the data in the DB
     The picker only accept date before o the same current date
     */
    @IBAction func setVisitedPlace(_ sender: Any) {
        var dateSelected = modelController.getCurrentDateTimeZone()
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
    
    /*
     Action for the Plan's button.
     If the place was planned before, an alert is shown telling the user the
     date previous schedule. If the user indicate yes, the date is updated. Else the alert is just closen.
     If the place wasnt planed before, just choose the date from a picker and the data is saved
     The picker only accept date after o the same current date
     */
    @IBAction func setPlannedPlace(_ sender: Any) {
        
        
        var dateSelected = modelController.getCurrentDateTimeZone()
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
            
        }
        let editUnitsAlert = UIAlertController(title: "Select the visited date", message: "", preferredStyle: UIAlertController.Style.alert)
        editUnitsAlert.setValue(vc, forKey: "contentViewController")
        editUnitsAlert.addAction(doneAction)
        editUnitsAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        let yesAction = UIAlertAction(title: "Yes", style: UIAlertAction.Style.default) {
            UIAlertAction in
            self.present(editUnitsAlert, animated: true)
        }
        
        modelController.wasPlacePlannedBefore(place: place!, completion: { planneDate, error in
            if let planneDate = planneDate {
                let dateFormatterPrint = DateFormatter()
                dateFormatterPrint.dateFormat = "dd MMM,yyyy"
                let formatDate = dateFormatterPrint.string(from: planneDate)
                let questionAlert = UIAlertController(title: "You have already planned it!", message: "You have schedule your visit to \(self.place!.name) on \(formatDate). Do you want to reschedule it?", preferredStyle: UIAlertController.Style.alert)
                questionAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: nil))
                questionAlert.addAction(yesAction)
                pickerView.setDate(planneDate, animated: true)
                self.present(questionAlert, animated: true)
            }
            else{
                if (self.presentedViewController == nil) {
                    self.present(editUnitsAlert, animated: true)
                }
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
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {

            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
}
