//
//  PlaceCollectionViewCell.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/16/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class PlaceCollectionViewCell: UICollectionViewCell {
    var place : Place?
    @IBOutlet weak var placeImageView: UIImageView!
    @IBOutlet weak var placeNameLabel: UILabel!
    @IBOutlet weak var placeCategoryLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    
    override func layoutSubviews(){
        placeCategoryLabel.numberOfLines = 3
        super.layoutSubviews()
        placeImageView.layer.cornerRadius = placeImageView.frame.width / 2.0
        placeImageView.layer.masksToBounds = true
        
        infoView.layer.borderWidth = 2.0
        infoView.layer.borderColor = UIColor(red:255/255.0, green:135.0/255.0, blue:107.0/255.0, alpha: 1.0).cgColor
    }
}
