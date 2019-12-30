//
//  MapViewController.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 11/10/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

var num = 0
var entered = false

class MapViewController: UIViewController {
    
    var activityIndicator: UIActivityIndicatorView = UIActivityIndicatorView()
    
    var locationManager = CLLocationManager()
    
    var currentPlacemark: CLPlacemark?
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet var mapContentBar: UIView!
    @IBOutlet var mapContentBarLabel: UILabel!
    @IBOutlet var mapContentBarDragView: UIView!
    
    // CONSTRAINTS
    @IBOutlet var mapContentBarHeight: NSLayoutConstraint!
    @IBOutlet var mapContentBarBottom: NSLayoutConstraint!
    
    var drawedDriection: Bool = false
    var didSelectAnnotation: Bool = false
    
        var addedAnnotations: [CLCircularRegion] = []
        var myLatitude: Double = 0.0
        var myLongitude: Double = 0.0
        
        var myLocValue = CLLocationCoordinate2D.self
    
        
    
    func setupActivityIndicator() {
        //activityIndicator.center.x = view.center.x
        activityIndicator.frame.origin = CGPoint(x: self.view.frame.width - 20, y: 20)
        //activityIndicator.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicator.hidesWhenStopped = true
        activityIndicator.color = UIColor(red:0.71, green:0.71, blue:0.71, alpha:1.0)
        mapContentBar.addSubview(activityIndicator)
    }
    
    override var prefersHomeIndicatorAutoHidden: Bool {
        return true
    }
    
    let regionRadius = 200.0
    
    
    var reachability: Reachinternet?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //printVenues()
        
        //self.mapView.addOverlay(route.polyline, level: .aboveRoads)
        
        locationManager.delegate = self;
        locationManager.distanceFilter = kCLLocationAccuracyNearestTenMeters;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        
        mapView.userTrackingMode = .follow
        mapContentBarDragView.layer.cornerRadius = 2
        mapContentBar.layer.cornerRadius = 20
        mapContentBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        mapContentBarHeight.constant = 200
        mapContentBarBottom.constant = mapContentBarHeight.constant - 120
        
        //stopNotifier()
        setupInternetReachability()
        startNotifier()
        
        let button = UIButton(frame: CGRect(x: 100, y: 100, width: 100, height: 50))
        button.backgroundColor = .green
        button.setTitle("Test Button", for: .normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)

        self.view.addSubview(button)
        
        let initialLocation = CLLocation(latitude: 46.2197679, longitude: 24.7919709)
        zoomMapOn(location: initialLocation)
        
//        let sampleStarbucks = Venue(title: "Starbucks Imagination", locationName: "imagination street", coordinate: CLLocationCoordinate2D(latitude: 46.2254829, longitude: 24.7946780))
//
//        mapView.addAnnotation(sampleStarbucks)
        
        mapView.delegate = self
        
        print("should set up data2")
        setupDetection()
        
        setupActivityIndicator()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("view will dissappear")
    }
    
    func setupInternetReachability() {
        //reachability = try? Reachability()
        
        reachability = try? Reachinternet()
        
        print("sets up inteactive reachability")
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reachabilityChanged),
            name: .reachabilityChanged,
            object: reachability
        )
    }
    
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachinternet
        
        print("entered reachability changed")
        
        if reachability.isReachable {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.mapContentBar.backgroundColor = .green
                }
            }
        } else {
            DispatchQueue.main.async {
                UIView.animate(withDuration: 0.5) {
                    self.mapContentBar.backgroundColor = .red
                }
            }
        }
        
//        if reachability.connection != .unavailable {
//            //updateLabelColourWhenReachable(reachability)
//            self.mapContentBar.backgroundColor = .green
//        } else {
//            //updateLabelColourWhenNotReachable(reachability)
//            self.mapContentBar.backgroundColor = .red
//        }
    }
    
    func startNotifier() {
        print("--- start notifier")
        do {
            try reachability?.startNotifier()
        } catch {
            print("failed to start notifier")
            return
        }
    }
    
    func stopNotifier() {
        print("--- stop notifier")
        reachability?.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: nil)
        reachability = nil
    }
    
    var appVC = AppViewController()
    
    @objc func buttonAction(sender: UIButton!) {
      //directionToPin()
        appVC.downloadJsonData()
        for n in stride(from: 1, to: pinData.count, by: 1){
            downloadPinImages(i: n)
        }
    }
    
    func setupDetection(){
        print("data is setting up2")
        if CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            
//            mapView.addAnnotations(venues)
//            
//            for i in stride(from: 0, to: venues.count, by: 1) {
//                let circle = MKCircle(center: venues[i].coordinate, radius: regionRadius)
//                mapView.addOverlay(circle)
//            }
            
//            let overlays = venues.map { MKCircle(center: $0.coordinate, radius: regionRadius) }
//            mapView.addOverlays(overlays)
            
            //print("mapview count = \(venues.count)")
//            let region1 = CLCircularRegion(center: venues[1].coordinate, radius: regionRadius, identifier: venues[1].title!)
//            locationManager.startMonitoring(for: region1)
            
//            for overlay in 1...self.mapView.overlays.count{
//                let region1 = CLCircularRegion(center: venues[overlay].coordinate, radius: regionRadius, identifier: venues[overlay].title!)
//                locationManager.startMonitoring(for: region1)
//                //print(venues[1].title!)
//            }
            
            //var regions = [CLCircularRegion]()
            
            var regions: [CLCircularRegion] = []
            var currentRegion: CLCircularRegion
            
//            for i in stride(from: 0, to: venues.count, by: 1) {
//                currentRegion = CLCircularRegion(center: venues[i].coordinate, radius: regionRadius, identifier: venues[i].title!)
//                regions = regions + [currentRegion]
//                //print("i1=\(i)")
//            }
            
            print(regions.count)

            for i in stride(from: 0, to: regions.count, by: 1) {
                locationManager.startMonitoring(for: regions[i])
                print("monitoring for  \(regions[i])")
            }
            
            //test
//                let title = "Lorrenzillo's"
//                       let coordinate = CLLocationCoordinate2DMake(37.703026, -121.759735)
//                       let regionRadius2 = 300.0
//
//                       // 3. setup region
//                       let region = CLCircularRegion(center: CLLocationCoordinate2D(latitude: coordinate.latitude,
//                           longitude: coordinate.longitude), radius: regionRadius2, identifier: title)
//                        locationManager.startMonitoring(for: region)
//
//                       // 4. setup annotation
//                       let restaurantAnnotation = MKPointAnnotation()
//                       restaurantAnnotation.coordinate = coordinate;
//                       restaurantAnnotation.title = "\(title)";
//                       mapView.addAnnotation(restaurantAnnotation)
//
//                       // 5. setup circle
//                       let circle = MKCircle(center: coordinate, radius: regionRadius2)
//                       mapView.addOverlay(circle)
            //
        } else {
            print("tracking not working")
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        checkLocationServicesAuthentificationStatus()
        
        entered = true
    }
    
    class CustomPointAnnotation: MKPointAnnotation {
        var imageName: UIImage!
    }
    
    var pinImages: [UIImage] = []
    var pinToAdd = CustomPointAnnotation()
    
    func setupPins() {
        print("shoul work!!!!")
        for i in stride(from: 0, to: pinData.count, by: 1) {
            if pinData[i].type == "annotation" {
            var pinLocation: CLLocationCoordinate2D = CLLocationCoordinate2DMake(pinData[i].location.lat, pinData[i].location.lng)
            pinToAdd = CustomPointAnnotation()
            pinToAdd.coordinate = pinLocation
            pinToAdd.title = pinData[i].name
            pinToAdd.subtitle = pinData[i].description
            mapView.addAnnotation(pinToAdd)
            
            pinToAdd.imageName = pinImagesDownloaded[i]
            //downloadPinImages(i: i)
                
            print("images count = \(self.pinImages.count)")
            //print(pinImages[i])
                
            }
        }
    }
    
    func downloadPinImages(i: Int) {
        print("enterd 1")
        if let imageUrl = URL(string: pinData[i].pinImage) {
            print("enterd 2")
                let data = try? Data(contentsOf: imageUrl)
                if let data = data {
                    let downloadedPinImage = UIImage(data: data)
                        self.pinImages.append(downloadedPinImage!)
                        pinToAdd.imageName = downloadedPinImage
                        print("should have appended")
                } else {
                    print("couldn't download images")
                }
        } else {
            print("failed getting url")
        }
    }
    
    var j = 0
    
    func printAnnotations() {
        for annotation in mapView.annotations {
            print(annotation.title)
        }
    }
    
    func printVenues() {
        for i in stride(from: 0, to: pinData.count, by: 1) {
            print(pinData[i].id)
            print(pinData[i].name)
            print(pinData[i].description)
            print(pinData[i].contact.phone)
            print(pinData[i].contact.gmail)
            print(pinData[i].socialMedia.twitter)
            print(pinData[i].socialMedia.facebook)
            print(pinData[i].location.adress)
            print(pinData[i].location.lat)
            print(pinData[i].location.lng)
            print()
        }
    }
    
    private let regionZoomRadius: CLLocationDistance = 1000
    
    func zoomMapOn(location: CLLocation){
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate, latitudinalMeters: regionZoomRadius * 2.0, longitudinalMeters: regionZoomRadius * 2.0)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func checkLocationServicesAuthentificationStatus(){
        locationManager.delegate = self
        if CLLocationManager.authorizationStatus() == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            locationManager.startUpdatingLocation()
            
            DispatchQueue.main.async {
                self.startTimerLoading()
            }
            
            print(self.mapView.annotations.count)
            
//            repeat {
//            } while loaded != true


            
        } else {
            locationManager.requestWhenInUseAuthorization()
            locationManager.startUpdatingLocation()
        }
    }
    
    var stopTimer = false
    var m = 0
    var executeOnce = true

    func startTimerLoading(){
        Timer.scheduledTimer(withTimeInterval: 0.2, repeats: true) { timer in
            print("Timer fired!")
            
            if (loaded == true) {
                if self.executeOnce {
                    self.setupPins()
                    self.printAnnotations()
                    self.executeOnce = false
                }
                self.stopTimer = true
                timer.invalidate()
                self.mapContentBarLabel.text = "loaded"
                self.activityIndicator.stopAnimating()
                print(self.mapView.annotations.count)
            } else {
                self.m = self.m + 1
                self.activityIndicator.startAnimating()
                //print("loading \(self.i)")
                self.mapContentBarLabel.text = "loading..."
            }
            
        }
        
    }
    
}

extension MapViewController : CLLocationManagerDelegate{
    // 1. user enter region
//    func locationManager(manager: CLLocationManager, didEnterRegion region: MKOverlay) {
//        print("enter \(region)")
//    }
//
//    // 2. user exit region
//    func locationManager(manager: CLLocationManager, didExitRegion region: MKOverlay) {
//        print("exit \(region)")
//    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion) {
        showAlert("enter \(region.identifier)")
        print("entered \(region.identifier)")
        mapContentBarLabel.text = region.identifier
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion) {
        showAlert("exit \(region.identifier)")
        print("exited \(region.identifier)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        //let location = locations.last!
        //print("j3")
        self.mapView.showsUserLocation = true
        
        //var clLocationAnnotation: CLLocation =  CLLocation(latitude: myRandomLatitude, longitude: myRandomLongitude)
        //let location = CLLocation(latitude: myLatitude, longitude: myLongitude)
        //let distance = location.distance(from: clLocationAnnotation)
        
//        if distance <= 200 {
//            //print("near location !!!!!")
//        } else {
//            //print("not near location !!!!!")
//        }
        
        if let location = locations.first {
            //myLatitude = location.coordinate.latitude
            //myLongitude = location.coordinate.longitude
        }
        
        let myLocValue: CLLocationCoordinate2D = manager.location!.coordinate

        //zoomMapOn(location: location)
    }
}



extension MapViewController: MKMapViewDelegate
{
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        directionToPin()
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView?
    {
        
        if !(annotation is CustomPointAnnotation) {
            return nil
        }
            
        var annotationView = self.mapView.dequeueReusableAnnotationView(withIdentifier: "Pin")

        if annotationView == nil{
            annotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: "Pin")
        }else{
            annotationView?.annotation = annotation
        }
        
        annotationView?.canShowCallout = true
        annotationView?.calloutOffset = CGPoint(x: -5, y: -5)
            
        let rcaButton = UIButton(frame: CGRect(x: 0, y: 0, width: 25, height: 25))
        rcaButton.setImage(UIImage(named: "navigationBarDirectionButtonBlue"), for: .normal)
        annotationView?.rightCalloutAccessoryView = rcaButton
        
        //let pinImg: UIImageView =
        let cpa = annotation as! CustomPointAnnotation
        
        if cpa.imageName == nil {
            annotationView?.image = UIImage(named: "popupWalkDeselectedLight")
        } else {
            annotationView?.image = cpa.imageName
        }
            
        guard !annotation.isKind(of: MKUserLocation.self) else {
                   //for the custom image on current location
                       //annotationView?.image = #imageLiteral(resourceName: "currentLocationPin")
            return annotationView
        }
            
        let scaleTransform = CGAffineTransform(scaleX: 0.0, y: 0.0)  // Scale
        UIView.animate(withDuration: 0.2, animations: {
            annotationView?.transform = scaleTransform
            annotationView?.layoutIfNeeded()
        }) { (isCompleted) in

            // Nested block of animation
        UIView.animate(withDuration: 0.3, animations: {
            annotationView?.alpha = 1.0
            annotationView?.transform = CGAffineTransform(scaleX: 1.0, y: 1.0)
            AnimationUtility.viewSlideInFromBottom(toTop: annotationView!)
            annotationView?.layoutIfNeeded()
            })
        }

        return annotationView
            
//            if let dequeuedView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier) as? MKPinAnnotationView {
//                dequeuedView.annotation = annotation
//                view = dequeuedView
//            } else {
//                view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: identifier)
//                view.canShowCallout = true
//                view.calloutOffset = CGPoint(x: -5, y: -5)
//                view.rightCalloutAccessoryView = UIButton(type: .detailDisclosure) as UIView
//                let rightButton = UIButton(type: .detailDisclosure)
//                view.rightCalloutAccessoryView = rightButton
//            }
            
//            return view
//        }
        
        //return nil
}
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer  {
        if overlay.isKind(of: MKCircle.self){
            let circleRenderer = MKCircleRenderer(overlay: overlay)
            circleRenderer.fillColor = UIColor.black.withAlphaComponent(0.5)
            circleRenderer.strokeColor = UIColor.blue
            circleRenderer.lineWidth = 2
            //print("circle")
            return circleRenderer
         }
        if overlay.isKind(of: MKPolyline.self){
            let polyRenderer = MKPolylineRenderer(overlay: overlay)
            polyRenderer.strokeColor = UIColor(red:0.05, green:0.31, blue:0.50, alpha:1.0)
            polyRenderer.lineWidth = 8.0
            //print("poly")
            return polyRenderer
        }
        
        return MKOverlayRenderer(overlay: overlay)
    }
    
//    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
//        let renderer = MKPolylineRenderer(overlay: overlay)
//
//        renderer.strokeColor = UIColor(red:0.05, green:0.31, blue:0.50, alpha:1.0)
//        renderer.lineWidth = 8.0
//
//        return renderer
//    }
 
    func showAlert(_ title: String) {
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        self.present(alert, animated: true, completion: nil)

    }
    
}
