//
//  VisitedPlaces.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/23/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import Foundation

class VisitedPlaces {
    let date : Date
    let places : Place
    
    init(date: Date, places: Place) {
        self.date = date
        self.places = places
    }
}
