//
//  Fetch.swift
//  freshpoint
//
//  Created by Michal Marhan on 22.04.2023.
//

import Foundation

class FoodItemFetcher {
    
    func fetchCatalog() async throws -> FridgeCatalog {
//        var freshpointCatalog = FreshPointCatalog(categories: [String](), products: [FoodItem]())
        print("fetching catalog data")
        let defaults = UserDefaults.standard
        let selectedFridge = defaults.object(forKey: Constants.userDefaultsKeys.selectedFridge.rawValue) as? Int ?? 298
        guard let url = URL(string: "api/fridges/" + String(selectedFridge), relativeTo: Constants.baseURL) else {
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
    
    func fetchFridges() async throws -> [Fridge] {
        print("fetching Fridges list")
        guard let url = URL(string: "api/fridges", relativeTo: Constants.baseURL) else {
            throw NetworkError.badURL
        }
        
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let fridges = try JSONDecoder().decode([Fridge].self, from: data)
            return fridges
        } catch {
            print(error)
            throw NetworkError.fetchFailed
        }
    }
}
