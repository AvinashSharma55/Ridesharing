//
//  Constants.swift
//  Ridesharing
//
//  Created by Avinash Sharma on 19/11/18.
//  Copyright © 2018 Moveinsync. All rights reserved.
//

import Foundation

let baseOriginLatitudeLongitudeString = "12.9123,77.6434" //MoveInSync
let baseDestinationLatitudeLongitudeString = "12.966210,77.636597" //Housejoy
let BaseURL = "https://maps.googleapis.com/maps/api/distancematrix/json?"


public func validateLatLong(originLat : String? , originLong : String? , destLat : String? , destLong : String?) -> Bool
{
    let originLatD = Double(originLat ?? "") ?? Double.greatestFiniteMagnitude
    let originLongD = Double(originLong ?? "") ?? Double.greatestFiniteMagnitude
    let destLatD = Double(destLat ?? "") ?? Double.greatestFiniteMagnitude
    let destLongD = Double(destLong ?? "") ?? Double.greatestFiniteMagnitude
    if( (originLatD > 90 || originLatD < -90) || (destLatD > 90 || destLatD < -90) || (originLongD > 180 || originLongD < -180) || (destLongD > 180 || destLongD < -180) ) {
        return false
    }
    return true
}
