//
//  NutritionInfo.swift
//  Lychee
//
//  Created by Divya Karivaradasamy on 3/2/20.
//  Copyright © 2020 Divya K. All rights reserved.
//

import Foundation

struct NutritionDetail : Decodable {
    let food: String
    let foodContentsLabel: String
}

struct NutritionInfo : Decodable {
    let parsed: [NutritionDetail]
    
}
