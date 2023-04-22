//
//  FoodProductCatalog.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

struct FreshPointCatalog {
    let categories: [String]
    let products: [FoodItem]
}

extension FreshPointCatalog: Decodable {}
