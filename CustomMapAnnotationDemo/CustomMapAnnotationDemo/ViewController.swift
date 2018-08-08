//
//  ViewController.swift
//  CustomMapAnnotationDemo
//
//  Created by Ho, Tsung Wei on 7/25/18.
//  Copyright © 2018 Michael T. Ho. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import CustomMapAnnotation

class ViewController: UIViewController {
    
    var mapView: MKMapView!
    
    /**
     Sample geo points
     */
    let geoCenter = (lat: 42.35619599, lng: -71.05957196)
    let geoPoint1 = (lat: 42.35273449, lng: -71.05580791)
    let geoPoint2 = (lat: 42.35307061, lng: -71.06350985)
    let geoPoint3 = (lat: 42.35130579, lng: -71.05916667)
    let geoPoint4 = (lat: 42.36098194, lng: -71.05897865)
    let geoPoint5 = (lat: 42.36326194, lng: -71.05080375)
    let geoPoint6 = (lat: 42.34798343, lng: -71.05960375)
    
    /**
     */
    let annotImg1 = StyledAnnotationView(annotImg: .gas, background: .square).toImage()
    let annotImg2 = StyledAnnotationView(annotImg: .police, background: .heart).toImage()
    let annotImg3 = StyledAnnotationView(annotImg: .hazard, background: .bubble).toImage()
    let annotImg4 = StyledAnnotationView(annotImg: .charging, background: .flag).toImage()
    let annotImg5 = StyledAnnotationView(annotImg: .personal, background: .circle, bgColor: UIColor.purple).toImage()
    let annotImg6 = StyledAnnotationView(annotImg: .hazard, background: .square, bgColor: UIColor.red).toImage()
    let annotImg7 = StyledAnnotationView(annotImg: .construction, color: UIColor.black, background: .flag, bgColor: UIColor.yellow).toImage()
    
    /**
     Declare a styled map annotation yourself
     */
    let yourAnnot = StyledAnnotationView(annotImg: UIImage(), background: UIImage()).toImage()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Init mapView
        mapView = MKMapView()
        mapView.isZoomEnabled = true
        mapView.delegate = self
        mapView.showsScale = true
        self.view.insertSubview(mapView, at: 0)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        // Layout mapView
        mapView.frame = self.view.frame
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Set region display
        let coordinate = CLLocationCoordinate2DMake(geoCenter.lat, geoCenter.lng)
        let region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03))
        mapView.setRegion(region, animated: true)
        
        // Sample location and image set
        let imgSet = [annotImg1, annotImg2, annotImg3, annotImg4, annotImg5, annotImg6, annotImg7]
        let locSet = [geoCenter, geoPoint1, geoPoint2, geoPoint3, geoPoint4, geoPoint5, geoPoint6]
        
        // Add custom map annotations to map
        for i in 0..<locSet.count {
            let annotation = createAnnotation(annotImg: imgSet[i], loc: locSet[i])
            mapView.addAnnotation(annotation)
        }
    }
    
    /**
     Create 
     */
    func createAnnotation(annotImg: UIImage, loc: (lat: Double, lng: Double)) -> MKAnnotation {
        let annot = CMAAnnotation()
        annot.coordinate = CLLocationCoordinate2D(latitude: loc.lat, longitude: loc.lng)
        annot.image = annotImg
        
        return annot
    }

    public enum AnnotAnimation {
        case zoomIn
        case zoomOut
        case bounceIn
    }
    
    /**
     Perform the animation to single annotation.
     
     - Parameters:
        - annotations: the target annotation view to perform animation
        - animation:   the animation type provided by MapLoader
        - duration:    the time duration of the animation
        - completion:  the task to do after the animation is finished
     */
    public func animate(annotations: [UIView], animation: AnnotAnimation, duration: TimeInterval = 0.5) {
        switch animation {
        case .zoomIn:
            annotations.forEach { $0.transform = CGAffineTransform.identity }
            UIView.animate(withDuration: duration, animations: {
                annotations.forEach { $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) }
            }, completion: nil)
        case .zoomOut:
            annotations.forEach { $0.transform = CGAffineTransform(scaleX: 1.5, y: 1.5) }
            UIView.animate(withDuration: duration, animations: {
                annotations.forEach { $0.transform = CGAffineTransform.identity }
            }, completion: nil)
        case .bounceIn:
            annotations.forEach {
                let offset = CGPoint(x: 0, y: $0.frame.height - $0.frame.minY)
                $0.transform = CGAffineTransform(translationX: offset.x + 0, y: offset.y + 0)
            }
            
            UIView.animate(
                withDuration: duration, delay: 0, usingSpringWithDamping: 0.58, initialSpringVelocity: 3,
                options: .curveEaseOut, animations: {
                    annotations.forEach {
                        $0.transform = .identity
                        $0.alpha = 1
                    }
            }, completion: nil)
        }
    }
}

extension ViewController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is MKUserLocation{
            return nil
        }else if let annotation = annotation as? CMAAnnotation {
            let identifier = "annot"
            var view = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if let view = view {
                view.annotation = annotation
            } else {
                view = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            view?.image = annotation.image
            
            return view
        }
        
        return nil
    }
    
    func mapView(_ mapView: MKMapView, didAdd views: [MKAnnotationView]) {
        animate(annotations: views, animation: .bounceIn)
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        animate(annotations: [view], animation: .zoomIn, duration: 0.3)
    }
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        animate(annotations: [view], animation: .zoomOut, duration: 0.3)
    }
}

class CMAAnnotation: MKPointAnnotation {
    var image: UIImage?
}

