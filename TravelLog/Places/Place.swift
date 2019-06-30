//
//  Place.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation

class Place {
    let id : Int
    let name : String
    let lat : Double
    let long : Double
    let description : String
    let photos : [String]
    let countryID : String
    
    init(id: Int, name: String, lat: Double, long:Double, description: String, photos: [String], countryID: String) {
        self.id = id
        self.name = name
        self.lat = lat
        self.long = long
        self.description = description
        self.photos = photos
        self.countryID = countryID
    }
}
