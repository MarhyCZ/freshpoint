//
//  FoodListViewModel.swift
//  freshpoint
//
//  Created by Michal Marhan on 27.04.2023.
//

import Foundation

@MainActor final class FoodListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case fetched
        case failed
    }
    
    @Published var state: State = .initial
    @Published var catalog: FridgeCatalog = FridgeCatalog(categories: [CategoryItem](), products: [FoodItem]())
    
    func fetch() async {
        state = .loading
        
        do {
            let data = try await FoodItemFetcher().fetch()
            print(data)
            catalog = data
            state = .fetched
        } catch {
            print("Error while fetching data for FoodListViewModel")
            state = .failed
        }
        
    }
}
