//
//  WelcomeVC.swift
//  Lychee
//
//  Created by Divya K on 2/18/19.
//  Copyright © 2019 Divya K. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var logo: UIImageView!
    var presentingDelegate:AppDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // rotate logo, then dismiss welcome view
        Helper.animateViewByDegrees(view: self.logo, degrees: 360, timeInterval: 1) { (x) in
            Helper.animateViewByDegrees(view: self.logo, degrees: 0, timeInterval: 1) { (x) in
                self.presentingDelegate?.dismissWelcomeVC()
            }
        }
    }
}

extension CATransition {
    // fade welcome
    func fadeTransition() -> CATransition {
        let transition = CATransition()
        transition.duration = 4.0
        transition.type = CATransitionType.fade
        transition.subtype = CATransitionSubtype.fromRight
        return transition
    }
}
