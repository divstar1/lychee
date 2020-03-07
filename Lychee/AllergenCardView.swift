//
//  AllergenCardView.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 3/5/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation
import UIKit

class AllergenCardView: UIView {
    @IBOutlet var allergenLabel: UILabel!
    
    func setUpCard() {
        backgroundColor = UIColor.white
        layer.cornerRadius = 10
        addCardShadow()
    }
    
    func addCardShadow() {
        Helper.addDropShadow(view: self, color: UIColor.black, opacity: 0.1, offsetWidth: 0, offsetHeight: -3, horizontalStretch: 1.65, verticalStretch: 1.5, shadowRadius: 4)
    }
    
    override var intrinsicContentSize: CGSize {
       return CGSize(width: 330, height: 70)
    }
    
}
