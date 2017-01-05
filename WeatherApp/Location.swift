//
//  Location.swift
//  WeatherApp
//
//  Created by Spencer Forrest on 05/01/2017.
//  Copyright © 2017 Spencer Forrest. All rights reserved.
//

import CoreLocation

class Location {
    static var sharedInstance = Location()
    private init(){}
    
    var latitude:Double!
    var longitude: Double!
}
