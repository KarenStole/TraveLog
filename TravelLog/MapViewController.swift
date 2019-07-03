//
//  MapViewController.swift
//  TravelLog
//
//  Created by Jose Soarez on 6/29/19.
//  Copyright © 2019 Jose Soarez. All rights reserved.
//

import UIKit
import MapKit
/*
 VC that show a Map with all the visited places in
 */
class MapViewController: UIViewController {

    var places : [VisitedPlaces] = []
   // let annotation = MKPointAnnotation()
    var annotations :[MKPointAnnotation] = []
    var zoomRect :MKMapRect = MKMapRect.null
    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    override func viewWillAppear(_ animated: Bool) {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "dd MMM,yyyy"
        for place in places {
            let annotation = MKPointAnnotation()
            annotation.coordinate = CLLocationCoordinate2D(latitude: (place.places.lat), longitude: (place.places.long))
            annotation.title = place.places.name
            annotation.subtitle = dateFormatterPrint.string(from: place.date)
            annotations.append(annotation)
        }
       mapView.addAnnotations(annotations)
        print(mapView.annotations)
        for annotation in mapView.annotations {
            let annotationPoint :MKMapPoint = MKMapPoint(annotation.coordinate);
            let pointRect : MKMapRect = MKMapRect(x: annotationPoint.x, y: annotationPoint.y, width: 0, height: 0);
            if (zoomRect.isNull) {
                zoomRect = pointRect;
            } else {
                zoomRect = zoomRect.union(pointRect);
            }
        }

        mapView.setVisibleMapRect(zoomRect, animated: true)
        mapView.showAnnotations(mapView.annotations, animated: true)
        

    }

}
