//
//  AllergensVC.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 3/5/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation
import UIKit

class AllergensController: UIViewController, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet var addAllergenButton: AddAllergenButton!
    
    @IBOutlet var allergenCardStackView: UIStackView!
    
    var allergenCount = 0
    
    override func viewDidLoad() {
        Helper.addDropShadow(view: addAllergenButton, color: UIColor.black, opacity: 0.1, offsetWidth: 0, offsetHeight: 15,
                             horizontalStretch: 1.15, verticalStretch: 1, shadowRadius: 2)
        loadAllergens()
    }
    
    func loadAllergens() {
        if let allergenListData = UserData.defaults.array(forKey: "userAllergens") as? [String] {
            
            for n in allergenCount...allergenListData.count - 1 {
                
                if let card = Bundle.main.loadNibNamed("AllergenCard", owner: self, options: nil)?[0] as? AllergenCardView {
                
                    card.setUpCard()
                    
                card.allergenLabel.text = allergenListData[n]
                allergenCardStackView.addArrangedSubview(card)
                    
                }
            }
            
            allergenCount = allergenCardStackView.arrangedSubviews.count
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "presentInputView" {
            if let controller = segue.destination as? InputAllergenVC {
                controller.popoverPresentationController!.delegate = self
            }
        }
    }
}
