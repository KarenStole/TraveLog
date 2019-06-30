//
//  PlannedPlacesViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/13/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class PlannedPlacesViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
}
extension PlannedPlacesViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return 10
            
        }
        
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let today = Date()
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "visitedCell", for: indexPath) as! MyPlacesCollectionViewCell
            cell.placeImageView.kf.setImage(with: URL(string: "https://d2z6c3c3r6k4bx.cloudfront.net/uploads/event/logo/1053664/3d32524b03040a6202008072a8f24b6a.jpg"))
            cell.placeNameLabel.text = "London"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "dd MMM,yyyy"
            cell.visitDateLabel.text = dateFormatterPrint.string(from: today)
            
            
            
            
            return cell
        }
        
    }



