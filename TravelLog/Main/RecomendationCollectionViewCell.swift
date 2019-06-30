//
//  RecomendationCollectionViewCell.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class RecomendationCollectionViewCell: UICollectionViewCell {
    var place : Place?
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeDescLabel: UILabel!
    
}
