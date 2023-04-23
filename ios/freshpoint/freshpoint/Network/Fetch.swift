//
//  Fetch.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

class FoodItemFetcher: ObservableObject {
    @Published var freshpointCatalog = FreshPointCatalog(categories: [String](), products: [FoodItem]())
    
    func fetch() async {
        guard let url = URL(string: "https://freshpoint.mb.marstad.cz/food") else { return }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            self.freshpointCatalog = try JSONDecoder().decode(FreshPointCatalog.self, from: data)
        } catch {
            print("Error decoding JSON: \(error)")
        }
    }
}
