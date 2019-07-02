//
//  CountryViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/16/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit

class CountryViewController: UIViewController {

    let modelManager = ModelManager.sharedModelManager
    var country : Country?
    var place : Place?
    var timer = Timer()
    var count = 0
    @IBOutlet weak var countryCollectionView: UICollectionView!
    @IBOutlet weak var placeCollectionView: UICollectionView!
    @IBOutlet weak var countryNameLabel: UILabel!
    
    @IBOutlet weak var pageController: UIPageControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        countryNameLabel.text = country?.name
        pageController.numberOfPages = (country?.photos.count)!
        pageController.currentPage = 0
        DispatchQueue.main.async {
            self.timer = Timer.scheduledTimer(timeInterval: 10.0, target: self, selector: #selector(self.changeImage), userInfo: nil, repeats: true)
        }


        
    }
    override func viewWillAppear(_ animated: Bool) {
    }
   @objc func changeImage(){
        if count < (country?.photos.count)!{
            let index = IndexPath.init(item: count, section: 0)
            self.countryCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: true)
            pageController.currentPage = count
            count += 1
        }else{
            count = 0
            let index = IndexPath.init(item: count, section: 0)
            self.countryCollectionView.scrollToItem(at: index, at: .centeredHorizontally, animated: false)
            pageController.currentPage = count
            count = 1
        }
    }

}
extension CountryViewController : UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is PlaceViewController{
            let destinationVC = segue.destination as! PlaceViewController
            destinationVC.place = place
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(self.countryCollectionView == collectionView){
            return country?.photos.count ?? 0
        }
        else{
            return country?.places?.count ?? 0
        }
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(self.countryCollectionView == collectionView){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "countryCell", for: indexPath) as! CountryCollectionViewCell
            cell.countryImageView.kf.setImage(with: URL(string: (country?.photos[indexPath.row])!))
            return cell
        }
        else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "placeCell", for: indexPath) as! PlaceCollectionViewCell
            cell.placeImageView.kf.setImage(with: URL(string: (country?.places![indexPath.row].photos[0])!))
            cell.placeNameLabel.text = country?.places![indexPath.row].name
            cell.placeCategoryLabel.text = country?.places![indexPath.row].description
            cell.place = country?.places![indexPath.row]
            return cell
        }
    
}
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        if(self.placeCollectionView == collectionView){
            let padding: CGFloat = 10
            let collectionCellSize = collectionView.frame.size.width - padding
            return CGSize(width: collectionCellSize/2, height: collectionCellSize*0.80)
            
        }
        else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(self.placeCollectionView == collectionView){
            let cell = self.placeCollectionView.cellForItem(at: indexPath) as! PlaceCollectionViewCell
            place = cell.place
            performSegue(withIdentifier: "goToPlaceDescription", sender: self)
        }
    }
}
