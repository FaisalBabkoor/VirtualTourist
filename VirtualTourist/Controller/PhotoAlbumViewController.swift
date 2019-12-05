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

class PhotoAlbumViewController: UIViewController, UIGestureRecognizerDelegate {
    
    @IBOutlet var mapView: MKMapView!
    @IBOutlet var collectionView: UICollectionView!
    @IBOutlet var noImageLabel: UILabel!
    
    
    let distansInMeters: Double = 10000
    var fetchResult: NSFetchedResultsController<Photo>!
    var pin: Pin!
    var location: CLLocationCoordinate2D?
    var page: Int = 0
    
    var isEmpty: Bool {
        if fetchResult.fetchedObjects?.count ?? 0 == 0 {
            return true
        }else {
            return false
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        fetch()
        collectionView.delegate = self
        collectionView.dataSource = self
        mapView.delegate = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //        guard let newLocation: CLLocationCoordinate2D = location else { return }
        guard let coordinate = location else { return }
        let region = MKCoordinateRegion(center: coordinate, latitudinalMeters: 1000000, longitudinalMeters: 1000000)
        //        mapView.centerCoordinate = newLocation
        //        mapView.setRegion(region, animated: true)
        let pointAnnotation = MKPointAnnotation()
        pointAnnotation.coordinate = coordinate
        mapView.setRegion(region, animated: true)
        print("latitude: \(coordinate.latitude) longitude \(coordinate.longitude)")
        mapView.addAnnotation(pointAnnotation)
    }
    
    
    func fetch() {
        let fetchReques: NSFetchRequest = Photo.fetchRequest()
        let sortDescriptor = NSSortDescriptor(key: "creationDate", ascending: true)
        let predicate = NSPredicate(format: "pin == %@", pin)
        
        fetchReques.predicate = predicate
        fetchReques.sortDescriptors = [sortDescriptor]
        fetchResult = NSFetchedResultsController(fetchRequest: fetchReques, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
        fetchResult.delegate = self
        do {
            try fetchResult.performFetch()
        } catch {
            print("No Data")
        }
    }
    
    
    @IBAction func newCollectionButtonWasPressed(_ sender: UIButton) {
        
        
        
    }
    
    
    
    
}
extension PhotoAlbumViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return fetchResult.sections?.count ?? 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fetchResult.sections?[0].numberOfObjects ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: Identifiers.CellsIdentifier.photoCell, for: indexPath) as? PhotoAlbumViewCell {
            //            let photo = fetchResult.object(at: indexPath)
            //            cell.configureCell(photo: photo)
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let collectionSize = collectionView.bounds
        return CGSize(width: collectionSize.width, height: collectionSize.height)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 3, bottom: 0, right: 3)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    
}

extension PhotoAlbumViewController: MKMapViewDelegate {
    
}
extension PhotoAlbumViewController: NSFetchedResultsControllerDelegate {
    //    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
    //        switch type {
    //        case <#pattern#>:
    //            <#code#>
    //        default:
    //            <#code#>
    //        }
    //    }
}
