//
//  Actor.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 23/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import UIKit
import MapKit

class Pins: Codable {
    let venues: [Pin]
    
    init(venues: [Pin]){
        self.venues = venues
    }
}

class Pin: Codable {
    
    let id: String
    let type: String
    let name: String
    let description: String
    let category: String
    let pinImage: String
    let contact: PinContact
    let socialMedia: PinSocialMedia
    let location: PinLocation
        
    init(id: String, type: String, name: String, description: String, category: String, pinImage: String, contact: PinContact, socialMedia: PinSocialMedia, location: PinLocation) {
        self.id = id
        self.type = type
        self.name = name
        self.description = description
        self.category = category
        self.pinImage = pinImage
        self.contact = contact
        self.socialMedia = socialMedia
        self.location = location
    }
}

class PinContact: Codable {
    let phone: Int
    let gmail: String
}

class PinSocialMedia: Codable {
    let twitter: String
    let facebook: String
}

class PinLocation: Codable {
    let adress: String
    let lat: Double
    let lng: Double
}

//var coordinate = CLLocationCoordinate2DMake(lat, lng)
