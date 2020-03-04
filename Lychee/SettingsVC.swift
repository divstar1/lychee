//
//  SettingsVC.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 2/25/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation
import UIKit

class SettingsVC: UIViewController {
    override func viewDidLoad() {
        navigationController?.navigationBar.isHidden = true
    }
    
    func setUpTransition() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromLeft
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
    }
    
    @IBAction func swipeLeft() {
        setUpTransition()
        tabBarController?.selectedIndex = 1
    }
}
