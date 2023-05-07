//
//  Fetch.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

class FoodItemFetcher {
    
    func fetch() async throws -> FridgeCatalog {
//        var freshpointCatalog = FreshPointCatalog(categories: [String](), products: [FoodItem]())
        print("fetching data")
        guard let url = URL(string: "https://freshpoint.mb.marstad.cz/food") else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let catalog = try JSONDecoder().decode(FridgeCatalog.self, from: data)
            return catalog
        } catch {
            print(error)
            throw NetworkError.fetchFailed
        }
    }
}
