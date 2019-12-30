//
//  Points.swift
//  xCodeMaps
//
//  Created by Cristea Octavian on 23/12/2019.
//  Copyright © 2019 Cristea Octavian. All rights reserved.
//

import Foundation

struct PointsResponse: Decodable {
    var response: Points
}

struct Points: Decodable {
    var venues: [PointsDetails]
}

struct PointsDetails: Decodable {
    var id: String
    var name: String
    var description: String
    var contact: PointsContact
    var socialMedia: PointsSocialMedia
    var location: PointsLocationInfo
}

struct PointsContact: Decodable {
    var phone: Int
    var gmail: String
}

struct PointsSocialMedia: Decodable {
    var twitter: String
    var facebook: String
}

struct PointsLocationInfo: Decodable {
    var adress: String
    var lat: Double
    var lng: Double
}
