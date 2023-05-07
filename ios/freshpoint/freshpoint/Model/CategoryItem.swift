//
//  CategoryItem.swift
//  freshpoint
//
//  Created by Michal Marhan on 06.05.2023.
//

import Foundation

struct CategoryItem {
    let name: String
    let products: [FoodItem]
}

// MARK: - Conformances
extension CategoryItem: Identifiable {
    var id: String {
        return self.name
    }
}
extension CategoryItem: Equatable {}
extension CategoryItem: Hashable {}
extension CategoryItem: Decodable {}
