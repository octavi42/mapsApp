//
//  File.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 25/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController {
        
        func directionToPin() {
            
            print(currentPlacemark)
            
            guard let currentPlacemark = currentPlacemark else {
                print("Error, the current Placemark is: \(self.currentPlacemark)")
                return
            }
            
            let directionRequest = MKDirections.Request()
            let destinationPlacemark = MKPlacemark(placemark: currentPlacemark)
            
            directionRequest.source = MKMapItem.forCurrentLocation()
            directionRequest.destination = MKMapItem(placemark: destinationPlacemark)
            directionRequest.transportType = .walking
            
            //calculate route
            let directions = MKDirections(request: directionRequest)
            directions.calculate{ (directionsResponse, error) in
                guard let directionsResponse = directionsResponse else{
                    if let error = error {
                        print("error getting directions: \(error.localizedDescription)")
                    }
                    return
                }
                
                let route = directionsResponse.routes[0]
                //self.mapView.removeOverlays(self.mapView.overlays)
                
                //let polyline = MKPolyline(coordinates: route, count: route.count)
                
                if self.drawedDriection == false{
                    self.drawedDriection = true
                    if self.didSelectAnnotation == true {
                        self.mapView.addOverlay(route.polyline, level: .aboveRoads)
                        //print(type(of: route.polyline))
                        // set red image
                        
                        var routeRect = route.polyline.boundingMapRect
                        routeRect.size.width = routeRect.size.width + 2000
                        routeRect.size.height = routeRect.size.height + 2000
                        routeRect.origin.x = routeRect.origin.x - 1000
                        routeRect.origin.y = routeRect.origin.y - 1000
                        
                        //print("----\(routeRect)----")
                        self.mapView.setRegion(MKCoordinateRegion(routeRect), animated: true)
                        
    //                    print("----\(MKCoordinateRegion(routeRect))----")

                    }
                } else {
                    
                    self.drawedDriection = false
                    
                    for overlay in self.mapView.overlays {
                        if overlay.isKind(of: MKPolyline.self) {
                            self.mapView.removeOverlay(overlay)
                        }
                    }
                    
                    if self.didSelectAnnotation == true {
                        
                        //set blue image
                        
                    } else {
                        
                        //set gray image
                        
                    }
                }
            }
        }
    
}
