//
//  DistanceMatrixModel.swift
//  Ridesharing
//
//  Created by Avinash Sharma on 19/11/18.
//  Copyright © 2018 Moveinsync. All rights reserved.
//

import Foundation

class DistanceMatrixModel {
    var destinationAddresses : [String]?
    var originAddresses : [String]?
    var status : String?
    var rows : [DistanceRows]?
    
    init(json : [String : Any]) {
        
        if let destinationAddresses = json["destination_addresses"]  as? [String] {
            self.destinationAddresses = destinationAddresses
        }
        if let originAddresses = json["origin_addresses"]  as? [String] {
            self.originAddresses = originAddresses
        }
        if let status = json["status"]  as? String {
            self.status = status
        }
        if let rows = json["rows"] as? [[String : Any]] {
            self.rows = DistanceRows.objectArrayFromDictArray(dictArray: rows)
        }
    }
    
}

class DistanceRows {
    
    var distanceElements : [DistanceElements]?
    
    init(json : [String : Any]) {
        
        if let elements = json["elements"] as? [[String :Any]] {
           self.distanceElements = DistanceElements.objectArrayFromDictArray(dictArray: elements)
        }
    }
    
    class func objectArrayFromDictArray(dictArray : [[String : Any]]) -> [DistanceRows] {
        var objectArray = [DistanceRows]()
        for dict in dictArray {
            objectArray.append(DistanceRows(json : dict))
        }
        return objectArray
    }
    
}

class DistanceElements {
    
    var  distance : Distance?
    var  duration : Distance?
    var  trafficDuration : Distance?
    var  status : String?
    init(json : [String : Any]) {
        if let distance = json["distance"] as? [String : Any] {
            self.distance = Distance.init(json: distance)
        }
        if let duration = json["duration"] as? [String : Any] {
            self.duration = Distance.init(json: duration)
        }
        if let trafficDuration = json["duration_in_traffic"] as? [String : Any] {
            self.trafficDuration = Distance.init(json: trafficDuration)
        }
        if let status = json["status"] as? String {
            self.status = status
        }
    }
    
    class func objectArrayFromDictArray(dictArray : [[String : Any]]) -> [DistanceElements] {
        var objectArray = [DistanceElements]()
        for dict in dictArray {
            objectArray.append(DistanceElements(json : dict))
        }
        return objectArray
    }
}

class Distance {
    var text : String?
    var value : Double?
    
    init(json : [String : Any]) {
        
        if let text = json["text"] as? String {
            self.text = text
        }
        if let value = json["value"] as? Double {
            self.value = value
        }
    }
}

