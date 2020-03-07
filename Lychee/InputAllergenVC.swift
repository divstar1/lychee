//
//  InputAllergenVC.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 3/6/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation
import UIKit

class InputAllergenVC: UIViewController {
    @IBOutlet weak var inputV: UIView!
    @IBOutlet var inputTextField: UITextField!
    @IBOutlet var addButton: UIButton!
    
    //var allergensView: AllergensController?
    
    override func viewDidLoad() {
        setUpInputView()
    }
    
    func setUpInputView() {
        inputV.layer.borderColor = UIColor(red: 102/255, green: 77/255, blue: 255/255, alpha: 1).cgColor
        inputV.layer.borderWidth = 1.5
        inputV.layer.cornerRadius = 10
        Helper.addDropShadow(view: addButton, color: UIColor.black, opacity: 0.1, offsetWidth: -5, offsetHeight: 15, horizontalStretch: 1.15, verticalStretch: 1, shadowRadius: 3)
    }
    
    @IBAction func addAllergen() {
        if let allergen = inputTextField.text {
            if var allergenListData = UserData.defaults.array(forKey: "userAllergens") {
                allergenListData.append(allergen)
                UserData.defaults.set(allergenListData, forKey: "userAllergens")
            } else {
                let newAllergenList = [allergen]
                UserData.defaults.set(newAllergenList, forKey: "userAllergens")
            }
        }
        
        inputTextField.text = ""
        dismiss()
    }
    
    @IBAction func clear() {
        inputTextField.text = ""
    }
    
    @IBAction func cancel() {
        self.dismiss(animated: true, completion: nil)
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        textField.resignFirstResponder()
    }
    
    func dismiss() {
        if let allergenListVC = popoverPresentationController?.delegate as? AllergensController {
            allergenListVC.loadAllergens()
        }
        self.dismiss(animated: true, completion: nil)
    }
}
