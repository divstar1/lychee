//
//  Helpers.swift
//  Lychee
//
//  Created by Divya K on 2/18/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import Foundation
import UIKit

class Helper {
    
    static func degreesToRadians(degrees:Int) -> Float {
        let radians = Float(degrees) * Float.pi / 180.0
        return radians
    }
    
    // rotate logo at launch
    static func animateViewByDegrees(view:UIView, degrees:Int, timeInterval:Double, completion:((Bool) -> Void)?) {
       
        let radians = CGFloat(degreesToRadians(degrees: degrees))
        
        UIView.animate(withDuration: timeInterval, animations: {
            if radians > CGFloat.pi {
                view.transform = CGAffineTransform.init(rotationAngle: CGFloat.pi)
            }
            view.transform = CGAffineTransform.init(rotationAngle: radians)
        }) { (x) in
            if let completion = completion {
                completion(x)
            }
        }
    }
    
    // set a request's http method, body, and additional values
    // perform the network request with the given url
    // perform callback
    static func performNetworkRequest(url:String,
                                      httpBody:Data?,
                                      httpMethod:String,
                                      requestHeaders:[String:String]?,
                                      callback:@escaping (Data?, URLResponse?, Error?)->Void)
        -> URLSessionDataTask?
    {
        guard let urlObject = URL(string:url) else {
            return nil
        }
        
        var request = URLRequest(url: urlObject)
        request.httpMethod = httpMethod
        request.httpBody = httpBody
        
        if let additionalValues = requestHeaders {
            for (key, value) in additionalValues {
                request.addValue(value, forHTTPHeaderField: key)
            }
        }
        
        let task = URLSession.shared.dataTask(with: request, completionHandler: callback)
        task.resume()
        
        return task
    }
    
    static func createJSONData(data: [String:Any]) -> Data {
        do {
            let json = try JSONSerialization.data(withJSONObject: data, options: .prettyPrinted)
            return json
        } catch {
            return Data()
        }
    }
    
    static func printOptionalString(s:String?) {
        if let s = s {
            print(s)
        }
    }
}
