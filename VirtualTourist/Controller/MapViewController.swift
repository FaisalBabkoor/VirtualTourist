//
//  MapViewController.swift
//  VirtualTourist
//
//  Created by Faisal Babkoor on 12/5/19.
//  Copyright © 2019 Faisal Babkoor. All rights reserved.
//

import UIKit
import MapKit
import CoreData

class MapViewController: UIViewController, UIGestureRecognizerDelegate, NSFetchedResultsControllerDelegate {

    @IBOutlet var mapView: MKMapView!
    
    var choosenLocation: MKCoordinateRegion!
    let distansInMeters: Double = 10000
    var fetchResult: NSFetchedResultsController<Pin>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mapView.delegate = self
        longPressGestureRecognizer()
        fetch()
        bringPins()
    }
    func bringPins() {
        if let pins = fetchResult.fetchedObjects {
               for pin in pins {
                   let center = CLLocationCoordinate2D(latitude: pin.latitude, longitude: pin.longitude)
                   let pointAnnotation = MKPointAnnotation()
                       pointAnnotation.coordinate = center
                   
                   mapView.addAnnotation(pointAnnotation)
               }
           }
           
    }
    func longPressGestureRecognizer() {
            let longPress = UILongPressGestureRecognizer(target: self, action: #selector(longPressed))
            longPress.delegate = self
            mapView.addGestureRecognizer(longPress)
           
                      
            
            
        }
        
        @objc func longPressed(_ sender: UILongPressGestureRecognizer) {
            let location = sender.location(in: mapView)
            let center = mapView.convert(location, toCoordinateFrom: mapView)
    //        let region = MKCoordinateRegion(center: center, latitudinalMeters: distansInMeters, longitudinalMeters: distansInMeters)
            let pin = MKPointAnnotation()
            pin.coordinate = center
            mapView.addAnnotation(pin)
            let newPin = Pin(context: DataController.shared.viewContext)
            newPin.latitude = center.latitude
            newPin.longitude = center.longitude
            if DataController.shared.viewContext.hasChanges {
                do {
                    try DataController.shared.viewContext.save()
                } catch {
                    print("Can't save data")
                }
            }
    //        mapView.setRegion(region, animated: true)
        }
        
        func getCenterLocation(for map: MKMapView) -> CLLocation {
            let longitude = mapView.centerCoordinate.longitude
            let latitude = mapView.centerCoordinate.latitude
            return CLLocation(latitude: latitude, longitude: longitude)
            
        }
    
    func fetch() {
          let fetchRequest: NSFetchRequest<Pin> = Pin.fetchRequest()
          let sortDescriptor = NSSortDescriptor(key: "longitude" , ascending: true)
          fetchRequest.sortDescriptors = [sortDescriptor]
          fetchResult = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: DataController.shared.viewContext, sectionNameKeyPath: nil, cacheName: nil)
          fetchResult.delegate = self
          do {
              try fetchResult.performFetch()
          } catch {
              fatalError("he fetch could not be performed: \(error.localizedDescription) ")
          }
          
          
      }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Identifiers.SegueIdentifier.toPhotoAlbumVC {
            if let photoVC = segue.destination as? PhotoAlbumViewController {
                print("HI")
            }
        }
    }


}
extension MapViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard annotation is MKPinAnnotationView else { return nil }
        var pinView = mapView.dequeueReusableAnnotationView(withIdentifier: Identifiers.PinIdentifier.pinID) as? MKPinAnnotationView
        if pinView == nil {
            pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: Identifiers.PinIdentifier.pinID)
            pinView!.pinTintColor = .red
            pinView!.animatesDrop = true
            pinView!.rightCalloutAccessoryView = UIButton(type: .detailDisclosure)
        } else {
            pinView!.annotation = annotation
        }
        return pinView
    }
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        performSegue(withIdentifier: Identifiers.SegueIdentifier.toPhotoAlbumVC, sender: nil)
    }
}
