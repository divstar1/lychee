//
//  ScannerVC.swift
//  Lychee
//
//  Created by Divya K on 2/18/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import Foundation
import AVFoundation
import UIKit

class ScannerVC: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
    var captureSession: AVCaptureSession!
    var previewLayer: AVCaptureVideoPreviewLayer!
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override func viewDidLoad() {
        setUpScanner()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        runCaptureSession()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        endCaptureSession()
    }
    
    func setUpScanner() {
        view.backgroundColor = UIColor.black
        
        // set up an AVCaptureSession
        captureSession = AVCaptureSession()
        
        // select the appropriate device for the media type
        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return }
        
        // get input for the capture device
        guard let videoInput = getVideoInput(captureDevice: videoCaptureDevice) else { return }
        
        addInputToCaptureSession(captureSession: captureSession, input: videoInput)
        
        // store metadata objects emitted by video capture for processing
        // specifically, capture barcodes
        setUpBarcodeRecognition(captureSession: captureSession)

        setUpPreviewLayer()
    }
    
    func runCaptureSession() {
        // start capture session, if not running
        if let captureSession = captureSession {
            if !(captureSession.isRunning) {
                captureSession.startRunning()
            }
        }
    }
    
    func endCaptureSession() {
        // stop capture session, if running
        if let captureSession = captureSession {
            if captureSession.isRunning {
                captureSession.stopRunning()
            }
        }
    }
    
    func getVideoInput(captureDevice:AVCaptureDevice) -> AVCaptureDeviceInput? {
        // if device supports video input, return the input structure
        let videoInput: AVCaptureDeviceInput
        do {
            videoInput = try AVCaptureDeviceInput(device: captureDevice)
            return videoInput
        } catch {
            return nil
        }
    }
    
    func addInputToCaptureSession(captureSession:AVCaptureSession, input:AVCaptureDeviceInput) {
        // if session supports video capture
        if captureSession.canAddInput(input) {
            captureSession.addInput(input)
        } else {
            failed()
            return
        }
    }
    
    func setUpBarcodeRecognition(captureSession:AVCaptureSession) {
        let metadataOutput = AVCaptureMetadataOutput()
        
        // capture barcode metadata captured by video session
        if captureSession.canAddOutput(metadataOutput) {
            metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
            captureSession.addOutput(metadataOutput)
            metadataOutput.metadataObjectTypes = [.ean8, .ean13, .pdf417, .upce]
        } else {
            failed()
            return
        }
    }
    
    func setUpPreviewLayer() {
        self.previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        self.previewLayer.frame = view.layer.bounds
        self.previewLayer.videoGravity = .resizeAspectFill
        self.view.layer.addSublayer(previewLayer)
    }
    
    func failed()  {
        captureSession = nil
    }
    
    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        // end capture session
        captureSession.stopRunning()
        
        // if metadata exists, and is readable, attempt to convert to string
        // play capture sound
        // handle barcode in codeFound function
        if let metadataObject = metadataObjects.first {
            guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else {return}
            guard let stringValue = readableObject.stringValue else {return}
            AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
            codeFound(code: stringValue)
        }
        
        self.dismiss(animated: true, completion: nil)
    }
    
    func codeFound(code: String) {
        // handle api call with upc code
        upc = code
        fetchIngredients(callback: ingredientsFetched)
    }
    
    var upc = "044000032197"
    let appID = "5c01a1fd"
    let appKey = "2c98e3314eb31470f581a3f531f5fe3b"
    
    func fetchIngredients(callback:@escaping ([String]) -> Void) {
        // get food from barcode
        // if food is valid, extract identifying data and request ingredients from nutrition API
        
        foodFromUPCRequest(upc: upc) { (result) in
            if let result = result, let keyFoodData = self.extractKeyFoodData(foodDataDictionary: result) {
                let foodData = Helper.createJSONData(data: ["ingredients":[keyFoodData]])
                self.nutritionFromFoodDataRequest(foodDataJSON: foodData, callback:callback)
            }
        }
    }
    
    func foodFromUPCRequest(upc:String, callback:@escaping ([String:Any]?) -> Void) {
        // perform network call to food fata base
        // if successful, parse the given JSON and send to callback
        let urlStr = "https://api.edamam.com/api/food-database/parser?upc=\(upc)&app_id=\(appID)&app_key=\(appKey)"
        
        let _ = Helper.performNetworkRequest(url: urlStr, httpBody: nil, httpMethod: "GET", requestHeaders: nil) { (data, response, error) in
            if let data = data {
                do {
                    let jsonSerialized = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any]
                    
                    if let json = jsonSerialized {
                        callback(json)
                    }
                } catch let error as NSError {
                    print(error.localizedDescription)
                    callback(nil)
                }
            } else if let error = error {
                print(error.localizedDescription)
                callback(nil)
            }
        }
    }
    
    func extractKeyFoodData(foodDataDictionary:[String:Any]) -> [String:Any]? {
        // given data for a particular food, extract its quantity, measure units, and unique ID
        // this data will be sent to the nutrition call
        
        if let hints = foodDataDictionary["hints"] as? [[String:Any]],
            let foodItem = hints[0]["food"] as? [String:Any],
            let foodId = foodItem["foodId"] as? String,
            let measures = hints[0]["measures"] as? [[String:Any]],
            let measureURI = measures[0]["uri"] as? String {
            return ["quantity":1, "measureURI":measureURI, "foodId":foodId]
        } else {
            return nil
        }
    }
    
    func nutritionFromFoodDataRequest(foodDataJSON:Data, callback:@escaping ([String]) -> Void)  {
        // modify JSON file and send to network request function
        // catch errors, otherwise print nutrition data to console
        let urlStr = "https://api.edamam.com/api/food-database/nutrients?app_id=\(appID)&app_key=\(appKey)"
        
        let _ = Helper.performNetworkRequest(url: urlStr, httpBody: foodDataJSON, httpMethod: "POST", requestHeaders: ["Content-Type":"application/json"]) { (data, response, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let ingredients = self.getIngredientsFromNutritionData(nutritionData: data)
                DispatchQueue.main.async {
                    callback(ingredients)
                }
            }
        }
    }
    
    func getIngredientsFromNutritionData(nutritionData:Data) -> [String] {
        let nutritionJSON = try? JSONSerialization.jsonObject(with: nutritionData, options: []) as? [String:Any]
        
        if let nutritionJSON = nutritionJSON,
            let ingredients = nutritionJSON?["ingredients"] as? [Any],
            let firstIngredient = ingredients[0] as? [String:Any],
            let parsed = firstIngredient["parsed"] as? [[String:Any]],
            let foodContentsLabel = parsed[0]["foodContentsLabel"] as? String {
            return getIngredients(foodContents: foodContentsLabel)
        }
        
        return [String]()
    }
    
    func getIngredients(foodContents:String) -> [String] {
        let ingredients = foodContents.components(separatedBy: CharacterSet(charactersIn: ";()."))

        var result = [String]()
        
        for item in ingredients {
            let trimmedItem = item.trimmingCharacters(in: CharacterSet(charactersIn: " "))
            if (trimmedItem.count != 0) {
                result.append(trimmedItem)
            }
        }
        
        return result
    }
    
    func ingredientsFetched(ingredients: [String]) {
        print(ingredients)
    }
}
