//
//  selNotSelAnnotationEX.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 25/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import Foundation
import MapKit

extension MapViewController {
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {
        didSelectAnnotation = true
        if drawedDriection == false{
            
            //directionToPin()
            print("pressed")
            //set blue image
                
                //directionButtonColor = "blue"
                //self.delegateChangeColors?.changeDirectionButtonColor()
        }
            
        if let location = view.annotation {
            print("ahskahukj")
            
            self.currentPlacemark = MKPlacemark(coordinate: location.coordinate)
            //print("current placemark: \(currentPlacemark)")
            //print("my current: \(view.annotation as? MKPointAnnotation)")
            //print("mapview annotations: \(self.mapView.annotations)")
                
        }
    }
    
    
    func mapView(_ mapView: MKMapView, didDeselect view: MKAnnotationView) {
        
        print("deselected")
        
        didSelectAnnotation = false
        if drawedDriection == false{
             
            //set gray button image
            
                    //directionButtonColor = "gray"
                    //self.delegateChangeColors?.changeDirectionButtonColor()
        }
    }
}
