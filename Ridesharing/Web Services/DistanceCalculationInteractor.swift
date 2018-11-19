//
//  DistanceCalculationInteractor.swift
//  Ridesharing
//
//  Created by Avinash Sharma on 19/11/18.
//  Copyright © 2018 Moveinsync. All rights reserved.
//

import UIKit
import Alamofire

protocol DistanceCalculationInteractorProtocol {
    func didReceiveResponse(distanceMatrixObject : DistanceMatrixModel?)
    func didFailToReceiveResponse()
}

class DistanceCalculationInteractor: NSObject {

    var distanceCalculationInteractorProtocolDelegate: DistanceCalculationInteractorProtocol?
    
    func getDistanceOfPointsFromGoogleApi(originLatitudeLongitudeString : String , destinationLatitudeLongitudeString : String) {
       let originString = "origins=" + baseOriginLatitudeLongitudeString + "|" + originLatitudeLongitudeString + "|" + destinationLatitudeLongitudeString + "&"
        let destinationString = "destinations=" + baseDestinationLatitudeLongitudeString + "|" + originLatitudeLongitudeString + "|" + destinationLatitudeLongitudeString
        let apiString = "&departure_time=now&key=AIzaSyBTREui0IBFNzBoNTNZlYjNCw-OCkSKfk4"
        let comepleteString = BaseURL + originString + destinationString + apiString
        guard let escapedQuery = comepleteString.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed),
            let url = URL(string: escapedQuery)
        else { self.distanceCalculationInteractorProtocolDelegate?.didFailToReceiveResponse()
                return }
        Alamofire.request(url, method: .get, parameters: nil).validate().responseJSON
            { response in
                guard response.result.isSuccess else {return}
                if let dicData = response.result.value as? [String : Any] {
                    let flag = 1
                    print(flag)
                    print(dicData)
                    let distanceMatrixModel = DistanceMatrixModel.init(json: dicData)
               self.distanceCalculationInteractorProtocolDelegate?.didReceiveResponse(distanceMatrixObject: distanceMatrixModel)
                }
                
        }
    }
}
