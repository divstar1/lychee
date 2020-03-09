//
//  AllergensDetectedVC.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 3/6/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation
import UIKit

class AllergensDetectedVC: UIViewController {
        
    @IBOutlet var allergensStackView: UIStackView!
    
    
    override func viewDidLoad() {
        
        guard let allergens = UserData.defaults.array(forKey: "userAllergens") as? [String] else {return}
        
        guard let ingredients = UserData.defaults.array(forKey: "ingredients") as? [String] else {return}
        
        for a in allergens {
            if ingredients.contains(a.uppercased()) {
               let label = UILabel()
                label.text = a
                label.textColor = UIColor.white
                label.font = UIFont(name: "OpenSans", size: 18)
                allergensStackView.addArrangedSubview(label)
            }
        }
    }
    
}
