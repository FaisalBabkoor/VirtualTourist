//
//  PhotoAlbumViewController.swift
//  VirtualTourist
//
//  Created by Faisal Babkoor on 12/5/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class PhotoAlbumViewController: UIViewController, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var choosenLocation: MKCoordinateRegion!
    let distansInMeters: Double = 10000
    var fetchResult: NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    

    

}
