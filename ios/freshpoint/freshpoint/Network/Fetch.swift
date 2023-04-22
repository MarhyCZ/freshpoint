//
//  Fetch.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

class FoodItemFetcher: ObservableObject {
    @Published var foodItems = [FoodItem]()
    
    init() async {
        guard let url = URL(string: "https://example.com/fooditems.json") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.foodItems = try JSONDecoder().decode([FoodItem].self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
