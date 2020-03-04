//
//  ScanItemVC.swift
//  Lychee
//
//  Created by Divya K on 3/28/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import Foundation
import UIKit

class ScanItemVC: UIViewController {
    override func viewDidLoad() {
        
    }
    
    func setUpTransition(direction: CATransitionSubtype) {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = direction
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @IBAction func swipeLeft() {
        setUpTransition(direction: CATransitionSubtype.fromLeft)
        tabBarController?.selectedIndex = 0
    }
    
    @IBAction func swipeRight() {
        setUpTransition(direction: CATransitionSubtype.fromRight)
        tabBarController?.selectedIndex = 2
    }
}
