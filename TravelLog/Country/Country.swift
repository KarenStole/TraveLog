//
//  Country.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/18/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation

class Country {
    
    let id : String
    let name : String
    let lat : Double
    let long : Double
    let description : String
    let photos : [String]
    var places : [Place]? = nil
    
    init(id: String, name:String, lat:Double, long:Double, description:String, photos: [String]) {
        self.id = id
        self.name = name
        self.lat = lat
        self.long = long
        self.description = description
        self.photos = photos
    }
}
