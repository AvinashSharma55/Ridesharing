//
//  ViewController.swift
//  Ridesharing
//
//  Created by Avinash Sharma on 19/11/18.
//  Copyright © 2018 Moveinsync. All rights reserved.
//

import UIKit

class ViewController: UIViewController , DistanceCalculationInteractorProtocol {

    

    @IBOutlet weak var originLatituteTextField : UITextField!
    @IBOutlet weak var originLongitudeTextField : UITextField!
    @IBOutlet weak var destinationLatitudeTextField : UITextField!
    @IBOutlet weak var destinationLongitudeTextField : UITextField!
    @IBOutlet weak var checkAvailabilityButton : UIButton!
    let locationInteractor = DistanceCalculationInteractor()
    lazy var activityIndicator : UIActivityIndicatorView  = {
        let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.gray)
        activityIndicator.hidesWhenStopped = true
        activityIndicator.center = self.view.center
        return activityIndicator
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpInputAccessoryView()
        self.view.addSubview(activityIndicator)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setUpInputAccessoryView() {
        let inputAccessoryView = UIToolbar()
        inputAccessoryView.sizeToFit()
        let flexBarButton = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        let doneBarButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(self.dismissKeyboard))
        inputAccessoryView.items = [flexBarButton, doneBarButton]
        self.originLatituteTextField.inputAccessoryView = inputAccessoryView
        self.originLongitudeTextField.inputAccessoryView = inputAccessoryView
        self.destinationLatitudeTextField.inputAccessoryView = inputAccessoryView
        self.destinationLongitudeTextField.inputAccessoryView = inputAccessoryView
    }
    
    @IBAction func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    @IBAction func checkAvailabilityButtonTapped(sender : Any) {
        
        if(self.validateLatitudeAndLongitudeValues() == true) {
            activityIndicator.startAnimating()
            locationInteractor.distanceCalculationInteractorProtocolDelegate = self
            locationInteractor.getDistanceOfPointsFromGoogleApi(originLatitudeLongitudeString:  self.originLatituteTextField.text! + "," + self.originLongitudeTextField.text!, destinationLatitudeLongitudeString: self.destinationLatitudeTextField.text! + "," + self.destinationLongitudeTextField.text!)
            
        }
        else {
            let alertController = UIAlertController(title: "Error", message: "Enter Valid Values", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: {
                self.clearTextFields()
            })
        }
    }
    func validateLatitudeAndLongitudeValues() -> Bool {
        
        return validateLatLong(originLat: self.originLatituteTextField.text, originLong: self.originLongitudeTextField.text, destLat: self.destinationLatitudeTextField.text, destLong: self.destinationLongitudeTextField.text)
    }
    
    func didReceiveResponse(distanceMatrixObject: DistanceMatrixModel?) {
        activityIndicator.stopAnimating()
        if (self.ifRideCanBeTaken(distanceMatrixObject: distanceMatrixObject) == true) {
            let alertController = UIAlertController(title: "Success", message: "You can take this ride", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: {
                self.clearTextFields()
            })
        }
        else {
            let alertController = UIAlertController(title: "OOPS", message: "You cannot take this ride", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(defaultAction)
            present(alertController, animated: true, completion: {
                self.clearTextFields()
            })

        }
        
    }
    
    func didFailToReceiveResponse() {
        activityIndicator.stopAnimating()
        let alertController = UIAlertController(title: "Error", message: "Something Went Wrong", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alertController.addAction(defaultAction)
        present(alertController, animated: true, completion: {
            self.clearTextFields()
        })
    }
    func ifRideCanBeTaken(distanceMatrixObject : DistanceMatrixModel?) -> Bool {
        var distanceBetweenBaseOriginAndBaseDest = Double()
        var distanceBetweenBaseOriginAndPickUpOrigin = Double()
        var distanceBetweenOriginAndDest = Double()
        var distanceBetweenDestAndBaseDest = Double()
        if let status = distanceMatrixObject?.rows?[0].distanceElements?[0].status {
            if status == "OK" {
                if let locVar = distanceMatrixObject?.rows?[0].distanceElements?[0].distance?.value {
                    distanceBetweenBaseOriginAndBaseDest = (locVar/1000)
                }
            }
        }
        if let status = distanceMatrixObject?.rows?[0].distanceElements?[1].status {
            if status == "OK" {
                if let locVar = distanceMatrixObject?.rows?[0].distanceElements?[1].distance?.value {
                    distanceBetweenBaseOriginAndPickUpOrigin = (locVar/1000)
                }
            }
        }
        if let status = distanceMatrixObject?.rows?[1].distanceElements?[2].status {
            if status == "OK" {
                if let locVar = distanceMatrixObject?.rows?[1].distanceElements?[2].distance?.value {
                    distanceBetweenOriginAndDest = (locVar/1000)
                }
            }
        }
        if let status = distanceMatrixObject?.rows?[2].distanceElements?[0].status {
            if status == "OK" {
                if let locVar = distanceMatrixObject?.rows?[2].distanceElements?[0].distance?.value {
                    distanceBetweenDestAndBaseDest = (locVar/1000)
                }
            }
        }
        let newDistance = distanceBetweenBaseOriginAndPickUpOrigin + distanceBetweenOriginAndDest + distanceBetweenDestAndBaseDest
        if ((distanceBetweenBaseOriginAndBaseDest + 1.5) <= newDistance) {
            return true
        }
        return false
    }
    func clearTextFields() {
        self.originLatituteTextField.text = nil
        self.originLongitudeTextField.text = nil
        self.destinationLatitudeTextField.text = nil
        self.destinationLongitudeTextField.text = nil
    }



}

