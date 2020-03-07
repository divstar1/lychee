//
//  MyAllergensVC.swift
//  Lychee
//
//  Created by Divya K on 2/19/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import Foundation
import UIKit

class MyAllergensVC: UIViewController {
    @IBOutlet weak var allergenList: UIStackView!
    @IBOutlet weak var allergenInputView: UIStackView!
    @IBOutlet weak var allergenInputTextField: UITextField!
    
    override func viewDidLoad() {
    }
    
    @IBAction func done() {
        allergenInputTextField.resignFirstResponder();
    }
    
    @IBAction func transitionToScan() {
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.moveIn
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        tabBarController?.selectedIndex = 1
    }
    
    @IBAction func newAllergenEntered() {
        if let allergen = allergenInputTextField.text {
            let allergenLabel = UILabel()
            allergenLabel.text = allergen
            allergenLabel.font = UIFont(name: "SFMono-Regular", size: 20)
            allergenLabel.textColor = UIColor.white
            allergenList.addArrangedSubview(allergenLabel)
            
            if var allergenListData = UserData.defaults.array(forKey: "userAllergens") {
                allergenListData.append(allergen)
                UserData.defaults.set(allergenListData, forKey: "userAllergens")
            } else {
                let newAllergenList = [allergen]
                UserData.defaults.set(newAllergenList, forKey: "userAllergens")
            }
        }
        
        allergenInputTextField.text = ""
        
    }
        
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
}
