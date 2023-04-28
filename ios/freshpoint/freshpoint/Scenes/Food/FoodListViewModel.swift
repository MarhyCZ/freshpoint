//
//  FoodListViewModel.swift
//  freshpoint
//
//  Created by Michal Marhan on 27.04.2023.
//

import Foundation

@MainActor final class CharacterListViewModel: ObservableObject {
    enum State {
        case initial
        case loading
        case fetched
        case ready
    }
}
