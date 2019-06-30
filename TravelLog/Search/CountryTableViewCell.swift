//
//  CountryTableViewCell.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
protocol DetailTableViewCellDelegate {
    func goToDetail(cell: CountryTableViewCell) -> Void}
class CountryTableViewCell: UITableViewCell {
    
    var country: Country? = nil

    var delegate : DetailTableViewCellDelegate?
    @IBOutlet weak var countryImageView: UIImageView!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    
    override func layoutSubviews(){
        descriptionLabel.numberOfLines = 3
        }

    @IBAction func goToCountryDetail(_ sender: Any) {
        delegate?.goToDetail(cell: self)
    }
}
