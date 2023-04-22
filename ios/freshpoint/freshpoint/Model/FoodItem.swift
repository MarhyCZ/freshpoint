//
//  FoodProduct.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

struct FoodItem {
    let category: String
    let name: String
    let imageURL: URL?
    let info: String
    let price: Int
    let quantity: Int
}

// MARK: - Conformances
extension FoodItem: Identifiable {
    var id: Int {
        return self.hashValue
    }
}
extension FoodItem: Equatable {}
extension FoodItem: Hashable {}
extension FoodItem: Decodable {}

// MARK: - Mock
#if DEBUG
extension FoodItem {

    static let mockedFoodProducts: [FoodItem] = [
        .init(
            category: "Nápoje",
            name: "Jax Coco 100% kokosová voda",
            imageURL: URL(string: "https://images.weserv.nl/?url=http://freshpoint.freshserver.cz/backend/web/media/photo/b8cc58cdf7ce2667e9386088322cd3f137d257b7485873c489a6d822b6ad04af.jpg"),
            info: "Super zdrava potravina",
            price: 20,
            quantity: 1
        ),
        .init(
            category: "Nápoje",
            name: "MAGU Synergy drink",
            imageURL: URL(string: "https://images.weserv.nl/?url=http://freshpoint.freshserver.cz/backend/web/media/photo/48d84b0dfa262a452a6580caf263492d1e53ef5c4587715214f8693c7843ed2e.jpg"),
            info: "Super zdrava potravina",
            price: 55,
            quantity: 4
        ),
    ]
}
#endif
