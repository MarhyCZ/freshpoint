//
//  FoodProductCatalog.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

struct FridgeCatalog {
    let categories: [CategoryItem]
    let products: [FoodItem]
}

extension FridgeCatalog: Decodable {}
