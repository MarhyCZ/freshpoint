//
//  FoodListViewModel.swift
//  freshpoint
//
//  Created by Michal Marhan on 27.04.2023.
//

import Foundation
import SwiftUI

@MainActor final class FoodListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case fetched
        case failed
    }
    
    @Published var state: State = .initial
    @Published var catalog: FridgeCatalog = FridgeCatalog(categories: [CategoryItem](), products: [FoodItem]())
    @Published var selectedFridge: Fridge?
    
    func fetch() async {
        state = .loading
        
        do {
            catalog = try await FoodItemFetcher().fetchCatalog()
            selectedFridge = try await FoodItemFetcher().fetchFridges().first(where: {$0.id == Settings.shared.selectedFridgeId })
            state = .fetched
        } catch {
            print("Error while fetching data for FoodListViewModel")
            state = .failed
        }
        
    }

}
