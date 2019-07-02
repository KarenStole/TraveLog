//
//  ModelManager.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Firebase

class ModelManager {
    
    static let sharedModelManager = ModelManager()
    let notification = LocalNotificationManager()
    var ref: DatabaseReference!
    var userID = ""
    
    
    private init(){
    }
    
    func getCountriesFromDatabase(completion: @escaping ([Country]?, Error?) -> Void){
        var countries : [Country] = []
        ref = Database.database().reference()
        ref.child("countries").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            for key in value!["countries"] as! [AnyObject]{
                var arrayOfPhotos = key["photos"] as! [AnyObject]
                arrayOfPhotos.remove(at: 0)
                let country = Country(id: key["id"] as! String, name: key["name"] as! String, lat: key["lat"] as! Double, long: key["long"] as! Double, description: key["description"] as! String, photos: arrayOfPhotos as! [String])
                countries.append(country)

            }
            completion(countries, nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil, error)
        }
        //return countries
    }
    
    func getPlacesFromDatabase(completion: @escaping ([Place]?, Error?) -> Void){
        var countries : [Place] = []
        ref = Database.database().reference()
        ref.child("places").observeSingleEvent(of: .value, with: { (snapshot) in
            // Get user value
            let value = snapshot.value as? [String: AnyObject]
            for key in value!["places"] as! [AnyObject]{
                var arrayOfPhotos = key["photos"] as! [AnyObject]
                arrayOfPhotos.remove(at: 0)
                let country = Place(id: key["id"] as! Int, name: key["name"] as! String, lat: key["lat"] as! Double, long: key["long"] as! Double, description: key["description"] as! String, photos: arrayOfPhotos as! [String], countryID: key["countryID"] as! String)
                countries.append(country)
                
            }
            completion(countries, nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil, error)
        }
        //return countries
    }
    
    func getCountriesName(countries : [Country]) -> [String] {
        var countriesNames : [String] = []
        for country in countries{
            countriesNames.append(country.name)
        }
        return countriesNames
    }
    
    func getPlacesIDVisitedByUID (uid: String, places: [Place], completion: @escaping ([VisitedPlaces]?, Error?) -> Void){
        var placesVisited : [VisitedPlaces] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        ref = Database.database().reference()
        ref.child("placesVisited").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value {
            for key in value["placesVisited"] as! [String:AnyObject]{
                if((key.value["userID"] as! String) == self.userID){
                    for place in places{
                        if(place.id == (key.value["placeID"] as! Int)){
                            let date = dateFormatter.date(from: (key.value["date"] as! String))!
                            let placeVisited = VisitedPlaces(date: date, places: place)
                            placesVisited.append(placeVisited)
                        }
                    }
                }
                
            }
            }
            completion(placesVisited, nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    func getPlacesIDPlanedByUID (uid: String, places: [Place], completion: @escaping ([VisitedPlaces]?, Error?) -> Void){
        var placesVisited : [VisitedPlaces] = []
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        ref = Database.database().reference()
        ref.child("plannedPlace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value{
            for key in value["plannedPlace"] as! [String: AnyObject]{
                if((key.value["userID"] as! String) == self.userID){
                    for place in places{
                        if(place.id == (key.value["placeID"] as! Int)){
                            let date = dateFormatter.date(from: (key.value["date"] as! String))!
                            let placeVisited = VisitedPlaces(date: date, places: place)
                            placesVisited.append(placeVisited)
                        }
                    }
                }
                
            }
            }
            completion(placesVisited, nil)
        }) { (error) in
            print(error.localizedDescription)
            completion(nil, error)
        }
    }
    
    func saveVisitedPlaces (place: VisitedPlaces){
        ref = Database.database().reference()
        ref.child("placesVisited").child("placesVisited").childByAutoId().setValue(["userID": self.userID, "date":         String(describing: place.date), "placeID": place.places.id])
    }
    
    func savePlannedPlaces (place: VisitedPlaces){
        let calendar1 = Calendar.current
        ref = Database.database().reference()
        ref.child("plannedPlace").child("plannedPlace").childByAutoId().setValue(["userID": self.userID, "date":         String(describing: place.date), "placeID": place.places.id], withCompletionBlock: {error, ref in
            if(error == nil){
                self.notification.notifications.append(Notification(id: "reminder-\(0)", title: "You have planned to visit \(place.places.name) today! Enjoy it!", datetime: DateComponents(calendar: Calendar.current, year: calendar1.component(.year, from: place.date), month: calendar1.component(.month, from: place.date), day: calendar1.component(.day, from: place.date), hour: calendar1.component(.hour, from: Date()), minute:calendar1.component(.minute, from: Date())+1 )))
                self.notification.schedule()
            }
        })
    }
    
    func updateVisitedPlaces (place: VisitedPlaces, completion: @escaping (Bool?, Error?) -> Void){
        var wasPreviousVisited = false
        var count = 0
        ref.child("placesVisited").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value {
            for visitedPlaces in (value["placesVisited"] as! [String: AnyObject]){
                    if((visitedPlaces.value["placeID"] as! Int) == place.places.id){
                       wasPreviousVisited = true
                        self.ref.child("placesVisited").child("placesVisited").child(visitedPlaces.key).updateChildValues(["userID": self.userID, "date":         String(describing: place.date), "placeID": place.places.id])
                    }
                    count = count + 1
                }
            }
            completion(wasPreviousVisited ,nil)
        }){(error) in completion(nil, error)}
    }
    
    func updatePlannedPlaces (place: VisitedPlaces, completion: @escaping (Bool?, Error?) -> Void){
        var wasPreviousVisited = false
        var count = 0
        ref.child("plannedPlace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value {
            for visitedPlaces in (value["plannedPlace"] as! [String: AnyObject]){
                if((visitedPlaces.value["placeID"] as! Int) == place.places.id){
                    wasPreviousVisited = true
                    self.ref.child("plannedPlace").child("plannedPlace").child(visitedPlaces.key).updateChildValues(["userID": self.userID, "date":         String(describing: place.date), "placeID": place.places.id])
                }
                }
                count = count + 1
            }
            completion(wasPreviousVisited ,nil)
        }){(error) in completion(nil, error)}
    }
    
    func wasPlacePlannedBefore (place: Place, completion: @escaping (Date?, Error?) -> Void){
        var visitedPlace = self.getCurrentDateTimeZone()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZZZ"
        ref.child("plannedPlace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value {
                for visitedPlaces in (value["plannedPlace"] as! [String: AnyObject]){
                    if((visitedPlaces.value["placeID"] as! Int) == place.id){
                        visitedPlace = dateFormatter.date(from: (visitedPlaces.value["date"] as! String))!
                            completion(visitedPlace ,nil)
                    }
                    else{
                        completion(nil ,nil)
                    }
                }
            }else{
                completion(nil ,nil)
            }

        }){(error) in completion(nil, error)}
    }

    
    func deletePlannedPlace(place: VisitedPlaces, completion: @escaping (Bool?, Error?) -> Void){
        var wasPreviousPlanned = false
        var count = 0
        ref.child("plannedPlace").observeSingleEvent(of: .value, with: { (snapshot) in
            let value = snapshot.value as? [String: AnyObject]
            if let value = value{
                for visitedPlaces in value["plannedPlace"] as! [String: AnyObject]{
                        if((visitedPlaces.value["placeID"] as! Int) == place.places.id){
                            wasPreviousPlanned = true
                            self.ref.child("plannedPlace").child("plannedPlace").child(visitedPlaces.key).removeValue()
                        }
                        count = count + 1
                }
            }
            completion(wasPreviousPlanned ,nil)
        }){(error) in completion(nil, error)}
    }
    
    func getNoVisitedPlacesVisitedOrPlanned(completion: @escaping ([Place]?, Error?) -> Void){
        var noPlacesVisited : [Place] = []
        getPlacesFromDatabase(completion: {places, error in
            if let places = places {
                self.getPlacesIDVisitedByUID(uid: self.userID, places: places, completion: {visitedPlace, error in
                    if let visitedPlace = visitedPlace{
                    noPlacesVisited = places.filter { (arg0) -> Bool in
                        var wasVisited = true
                        let (place) = arg0
                        for placeVisited in visitedPlace{
                            if (placeVisited.places.id == place.id){
                                wasVisited = false
                                break
                            }
                        }
                        return wasVisited
                    }
                    }})
                self.getPlacesIDPlanedByUID(uid: self.userID, places: places, completion: {plannedPlace, error in
                    if let plannedPlace = plannedPlace{
                        noPlacesVisited = noPlacesVisited.filter { (arg0) -> Bool in
                            var wasPlanned = true
                            let (place) = arg0
                            for placePlanned in plannedPlace{
                                if (placePlanned.places.id == place.id){
                                    wasPlanned = false
                                    break
                                }
                            }
                            return wasPlanned
                        }
                        completion(noPlacesVisited, nil)
                    }})
                
            }
            else{
                completion(nil, error)
            }
        })
        

        
    }
    
    func getCurrentDateTimeZone() -> Date{
        let currentDate = Date()
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = currentDate.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    func convertToCurrentTimeZone(date : Date) -> Date{
        
        // 1) Get the current TimeZone's seconds from GMT. Since I am in Chicago this will be: 60*60*5 (18000)
        let timezoneOffset =  TimeZone.current.secondsFromGMT()
        
        // 2) Get the current date (GMT) in seconds since 1970. Epoch datetime.
        let epochDate = date.timeIntervalSince1970
        
        // 3) Perform a calculation with timezoneOffset + epochDate to get the total seconds for the
        //    local date since 1970.
        //    This may look a bit strange, but since timezoneOffset is given as -18000.0, adding epochDate and timezoneOffset
        //    calculates correctly.
        let timezoneEpochOffset = (epochDate + Double(timezoneOffset))
        
        // 4) Finally, create a date using the seconds offset since 1970 for the local date.
        let timeZoneOffsetDate = Date(timeIntervalSince1970: timezoneEpochOffset)
        return timeZoneOffsetDate
    }
    
    func signOut(){
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
}
